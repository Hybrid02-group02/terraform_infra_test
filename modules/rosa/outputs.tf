output "rosa_cluster_id" {
  description = "The ID of the ROSA cluster"
  value       = var.cluster_name
}

output "rosa_cluster_name" {
  description = "ROSA 클러스터 이름"
  value       = var.cluster_name
}

variable "security_group_id" {
  description = "Security group ID to be used by ROSA worker nodes"
  type        = string
}




