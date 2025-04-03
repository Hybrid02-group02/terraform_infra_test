output "cluster_id" {
  description = "EKS 클러스터 ID"
  value       = aws_eks_cluster.main.id
}

output "cluster_endpoint" {
  description = "EKS 클러스터 엔드포인트"
  value       = aws_eks_cluster.main.endpoint
}

# output "cluster_security_group_id" {
#   description = "EKS 클러스터 보안 그룹 ID"
#   value       = aws_eks_cluster.main.vpc_config[0].security_group_ids[0]
# }
