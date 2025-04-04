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

# IAM 역할 리소스: ROSA 클러스터 관리에 필요한 IAM 역할 설정
resource "aws_iam_role" "rosa_role" {
  name = "${var.cluster_name}-rosa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "rosa.openshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM 역할에 필요한 정책들을 각각 연결
resource "aws_iam_role_policy_attachment" "rosa_installer" {
  policy_arn = "arn:aws:iam::aws:policy/ROSAInstallerPolicy"
  role       = aws_iam_role.rosa_role.name
}

resource "aws_iam_role_policy_attachment" "rosa_control_plane" {
  policy_arn = "arn:aws:iam::aws:policy/ROSAControlPlaneOperatorPolicy"
  role       = aws_iam_role.rosa_role.name
}

resource "aws_iam_role_policy_attachment" "rosa_ingress" {
  policy_arn = "arn:aws:iam::aws:policy/ROSAIngressOperatorPolicy"
  role       = aws_iam_role.rosa_role.name
}

resource "aws_iam_role_policy_attachment" "rosa_node_pool" {
  policy_arn = "arn:aws:iam::aws:policy/ROSANodePoolManagementPolicy"
  role       = aws_iam_role.rosa_role.name
}

resource "aws_iam_role_policy_attachment" "rosa_manage_subscription" {
  policy_arn = "arn:aws:iam::aws:policy/ROSAManageSubscription"
  role       = aws_iam_role.rosa_role.name
}

# resource "rosa_cluster" "rosa" {
#   name        = var.cluster_name
#   region      = var.region
#   vpc_id      = var.vpc_id
#   subnet_ids  = var.rosa_subnet_ids
#   version     = "4.9"  # 원하는 OpenShift 버전

#   node_pool {
#     name            = "node-pool"
#     instance_type   = var.instance_type
#     size            = var.min_replicas
#     min_replicas    = var.min_replicas
#     max_replicas    = var.max_replicas
#     enable_autoscaling = var.enable_autoscaling
#   }
# }

# OpenShift 클러스터 리소스: ROSA 클러스터를 Terraform을 통해 생성
resource "null_resource" "create_rosa_cluster" {
  depends_on = [
    null_resource.install_rosa_cli,  # rosa_cli 설치 후 실행됨
    null_resource.rosa_init,  # rosa_init이 완료된 후 실행됨
    aws_iam_role.rosa_role,
    aws_iam_role_policy_attachment.rosa_installer,
    aws_iam_role_policy_attachment.rosa_control_plane,
    aws_iam_role_policy_attachment.rosa_ingress,
    aws_iam_role_policy_attachment.rosa_node_pool,
    aws_iam_role_policy_attachment.rosa_manage_subscription
  ]
  provisioner "local-exec" {
    command = <<EOT
      rosa create cluster --cluster-name=${var.cluster_name} \
      --region=${var.region} \
      --subnet-ids=${join(",", var.rosa_subnet_ids)} \
      --multi-az \
      --machine-cidr=${var.vpc_cidr} \
      --replicas=${var.min_replicas} \
      --compute-machine-type=${var.instance_type} \
      --watch
    EOT
  }
}

# rosa CLI 설치: rosa CLI가 설치되지 않았다면 설치하는 null_resource
resource "null_resource" "install_rosa_cli" {
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
  depends_on = [null_resource.install_rosa_cli]  # rosa_cli가 설치된 후 실행됨
  provisioner "local-exec" {
    command = <<EOT
      export ROSE_TOKEN="${var.rosa_token}"
      echo $ROSE_TOKEN | rosa login --token=$ROSE_TOKEN
      rosa init
      rosa create account-roles --mode auto
    EOT
  }
}

# ROSA 클러스터 설치 상태 대기: 클러스터가 완전히 설치될 때까지 기다림
resource "null_resource" "wait_for_rosa_ready" {
  depends_on = [null_resource.create_rosa_cluster]

  provisioner "local-exec" {
    command = "rosa wait-for install --cluster=${var.cluster_name}"
  }
}

