output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

# output "ec2_instance_id" {
#   value = module.ec2.instance_id
# }

# output "ec2_public_ip" {
#   value = module.ec2.public_ip
# }

output "s3_bucket_id" {
  value = module.s3.bucket_id
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "waf_arn" {
  value = module.waf.waf_arn
}

#output "route53_record_fqdn" {
#  value = module.route53.record_fqdn
#}

output "eks_cluster_id" {
  description = "EKS Cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

