variable "cluster_name" {
  description = "ROSA 클러스터 이름"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "rosa_subnet_ids" {
  description = "ROSA 클러스터가 배포될 서브넷 ID 리스트"
  type        = list(string)
}

variable "instance_type" {
  description = "ROSA 노드 그룹의 인스턴스 타입"
  type        = string
  default     = "m5.large"
}

variable "min_replicas" {
  description = "ROSA 클러스터 최소 노드 개수"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "ROSA 클러스터 최대 노드 개수"
  type        = number
  default     = 4
}

# ec2_ansible
variable "ami_id" {
  description = "ansible용 ec2의 ami id"
  type        = string
  default     = "ami-0a463f27534bdf246"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "enable_autoscaling" {
  description = "ROSA 클러스터 노드 자동 스케일링 활성화 여부"
  type        = bool
}

# variable "ec2_subnet_id" {
#   description = "ROSA 클러스터 설정할 ansible용 ec2 서브넷 ID"
#   type        = string
# }

variable "rosa_token" {
  description = "ROSA token"
  type        = string
}

variable "oidc_config_path" {
  type        = string
  description = "Path to store OIDC config ID"
}

variable "redhat_url_path" {
  type        = string
  description = "Path to store redhat_url"
}

variable "security_group_id" {
  description = "Security group ID to be used by ROSA worker nodes"
  type        = string
}
