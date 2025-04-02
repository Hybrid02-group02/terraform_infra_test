variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "name" {
  description = "Name suffix for the WAF"
  type        = string
}

variable "environment" {
  description = "Environment (e.g. dev, prod)"
  type        = string
}

variable "scope" {
  description = "WAF scope: REGIONAL (for ALB) or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

variable "alb_arn" {
  description = "ARN of the ALB to associate WAF with"
  type        = string
  default     = ""
}

variable "associate_alb" {
  description = "Whether to associate WAF with ALB"
  type        = bool
  default     = false
}

