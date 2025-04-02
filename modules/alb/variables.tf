variable "project_name" {
  description = "Prefix for resource names"
  type        = string
}

variable "name" {
  description = "Name suffix for the ALB"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "internal" {
  description = "If true, creates an internal ALB"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on ALB"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy ALB in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group"
  type        = string
}

variable "target_port" {
  description = "Port the target group forwards to"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol for target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  description = "Protocol for health check"
  type        = string
  default     = "HTTP"
}
