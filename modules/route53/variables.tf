variable "domain_name" {
  description = "Route 53에서 관리할 도메인 이름"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB의 DNS 이름"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB의 Hosted Zone ID"
  type        = string
}
