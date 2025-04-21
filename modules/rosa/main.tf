terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# rosa CLI 설치: rosa CLI가 설치되지 않았다면 설치하는 null_resource
resource "null_resource" "install_rosa_cli" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      # Check if rosa CLI is installed, if not, install it
      if ! command -v rosa &> /dev/null
      then
        echo "rosa CLI not found, installing..."
        curl -O https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz
        tar -xvzf rosa-linux.tar.gz
        chmod +x rosa
        sudo mv rosa /usr/local/bin/
        echo "rosa CLI installed successfully"
      else
        echo "rosa CLI is already installed"
      fi
    EOT
  }
}

# rosa 초기화: rosa CLI를 로그인하고 필요한 계정 역할을 생성하는 작업
resource "null_resource" "rosa_init" {
  depends_on = [null_resource.install_rosa_cli] # rosa_cli가 설치된 후 실행됨

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      rosa login --token=${var.rosa_token}
      rosa init --yes
      rosa create account-roles --mode auto --hosted-cp --yes
      rosa create oidc-config --mode auto --yes
    EOT
  }
}

# oidc_config_id 파일을 생성하는 작업
resource "null_resource" "fetch_oidc_config_id" {
  depends_on = [null_resource.rosa_init]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      rosa login --token=${var.rosa_token}
      mkdir -p $(dirname ${var.oidc_config_path})
      rosa list oidc-config --output json \
        | grep -o '"id":[^,]*' \
        | head -n 1 \
        | cut -d':' -f2 \
        | tr -d ' "' \
        | tee ${var.oidc_config_path} > /dev/null

      # OIDC Provider 생성 시, 해당 ID를 사용하여 자동으로 OIDC Provider 생성
      oidc_id=$(cat ${var.oidc_config_path})
      rosa create oidc-provider --oidc-config-id $oidc_id --mode auto --yes
    EOT
  }
}

# OpenShift 클러스터 리소스: ROSA 클러스터를 Terraform을 통해 생성
resource "null_resource" "create_rosa_cluster" {
  depends_on = [
    null_resource.install_rosa_cli,     # rosa_cli 설치 후 실행됨
    null_resource.rosa_init,            # rosa_init이 완료된 후 실행됨
    null_resource.fetch_oidc_config_id, # oidc config ID가 준비된 후 실행됨
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      rosa login --token=${var.rosa_token}
      oidc_id=$(cat ${var.oidc_config_path})

      if ! rosa describe cluster -c ${var.cluster_name} &> /dev/null; then
        echo "▶ Creating new ROSA cluster..."
        rosa create cluster --hosted-cp \
          --cluster-name=${var.cluster_name} \
          --region=${var.region} \
          --subnet-ids=${join(",", var.rosa_subnet_ids)} \
          --machine-cidr=${var.vpc_cidr} \
          --enable-autoscaling \
          --min-replicas=${var.min_replicas} \
          --max-replicas=${var.max_replicas} \
          --compute-machine-type=${var.instance_type} \
          --oidc-config-id=$oidc_id \
          --additional-compute-security-group-ids=${var.security_group_id} \
          --yes
      else
        echo "▶ ROSA cluster '${var.cluster_name}' already exists. Skipping creation."
      fi
    EOT
  }
}

# operator-roles 생성
resource "null_resource" "create_operator_roles" {
  depends_on = [
    null_resource.create_rosa_cluster
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      rosa login --token=${var.rosa_token}

      echo "▶ Checking if cluster is in 'waiting' state to create operator roles..."
      status=$(rosa describe cluster -c ${var.cluster_name} -o json | grep '"state":' | head -n 1 | cut -d '"' -f4)

      if [ "$status" = "ready" ] || [ "$status" = "installing" ]; then
        echo "▶ Cluster state is '$status'. Skipping operator roles creation."
        exit 0
      fi

      echo "▶ Waiting until cluster is in 'waiting' state..."
      for i in {1..20}; do
        status=$(rosa describe cluster -c ${var.cluster_name} -o json | grep '"state":' | head -n 1 | cut -d '"' -f4)
        echo "Current state: $status"
        if [ "$status" = "waiting" ]; then
          echo "Cluster is in 'waiting' state. Proceeding with operator roles creation."
          break
        fi
        echo "Still not ready. Sleeping 30 seconds..."
        sleep 30
      done

      echo "Creating operator roles..."
      rosa create operator-roles --cluster=${var.cluster_name} --mode auto --yes
    EOT
  }
}


# ROSA 클러스터 설치 상태 대기: 클러스터가 완전히 설치될 때까지 기다림
resource "null_resource" "wait_for_rosa_ready" {
  depends_on = [
    null_resource.create_operator_roles
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      rosa login --token=${var.rosa_token}
      echo "Waiting for ROSA cluster to be ready..."
      until rosa describe cluster -c ${var.cluster_name} | grep -q "State:.*ready"; do
        echo "Cluster is still provisioning... sleeping for 30 seconds"
        sleep 30
      done
      echo "Cluster is ready!"
    EOT
  }
}

# 콘솔 URL 및 oc 로그인 명령어 추출
resource "null_resource" "fetch_console_url" {
  depends_on = [
    null_resource.wait_for_rosa_ready # 클러스터가 ready 상태가 된 후 실행
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      rosa login --token=${var.rosa_token}

      echo "▶ Creating cluster-admin user..."
      rosa create admin -c ${var.cluster_name} \
        | grep "oc login" | tee ${var.redhat_url_path}
      echo "" >> ${var.redhat_url_path}

      echo ""
      echo "▶ Fetching OpenShift console URL after cluster is ready..."
      mkdir -p $(dirname ${var.redhat_url_path})

      # 콘솔 URL을 얻기 위해 재시도
      for i in {1..30}; do
        url=$(rosa describe cluster -c ${var.cluster_name} -o json \
          | grep '"console":' -A 3 \
          | grep '"url":' \
          | cut -d '"' -f4 \
          | sed 's#console#openshift/details#')

        if [ -n "$url" ]; then
          break
        fi

        echo "Console URL not found yet. Retrying in 30 seconds... ($i/30)"
        sleep 30
      done

      if [ -z "$url" ]; then
        echo "❌ Console URL could not be retrieved after waiting. Exiting."
        exit 1
      fi

      echo "ROSA Console URL: $url" | tee -a ${var.redhat_url_path}

      echo "✅ Console URL and login command saved to: ${var.redhat_url_path}"
    EOT
  }
}