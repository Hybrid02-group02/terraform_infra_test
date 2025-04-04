variable "project_name" {
  description = "Project prefix used in naming resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

# variable "route53_zone_id" {
#  description = "The ID of the Route 53 Hosted Zone"
#  type        = string
# }

variable "route53_domain_name" {
 description = "Base domain name (e.g. dev.example.com)"
 type        = string
}

variable "route53_record_name" {
  default = "naddong.shop"  # 또는 "app.naddong.shop" 등 서브도메인을 원하면 변경
}


# ROSA variables
variable "cluster_name" {
  description = "ROSA 클러스터 이름"
  type        = string
}

variable "rosa_instance_type" {
  description = "ROSA 노드 그룹의 인스턴스 타입"
  type        = string
  default     = "m5.xlarge"
}

variable "enable_autoscaling" {
  description = "ROSA 클러스터 노드 자동 스케일링 여부"
  type        = bool
  default     = true
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

variable "rosa_subnet_ids" {
  description = "ROSA 클러스터가 배포될 서브넷 ID 리스트"
  type        = list(string)
}

variable "region" {
  description = "region for EC2 instance"
  type        = string
}


variable "ec2_subnet_id" {
  description = "ROSA 클러스터 설정할 ansible용 ec2 서브넷 ID"
  type        = string
}

variable "rosa_token" {
  description = "ROSA token"
  type        = string
}
