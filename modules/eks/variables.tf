variable "vpc_id" {
  description = "VPC 아이디"
  type        = string
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "private_subnet_ids" {
  description = "EKS Cluster subnet_ids"
  type        = list(string)
}

variable "instance_types" {
  description = "EKS 노드 그룹 인스턴스 타입"
  type        = list(string)
}

variable "desired_capacity" {
  description = "EKS 노드 그룹의 초기 사이즈"
  type        = number
}

variable "min_size" {
  description = "EKS 노드 그룹의 최소 노드 수"
  type        = number
}

variable "max_size" {
  description = "EKS 노드 그룹의 최대 노드 수"
  type        = number
}
