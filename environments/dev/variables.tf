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

# EKS Variables
variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}


