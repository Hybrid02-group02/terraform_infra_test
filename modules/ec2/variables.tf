variable "project_name" {
  description = "Prefix for resource names"
  type        = string
}

variable "name" {
  description = "Name tag for the instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be deployed"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script (bash)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group to attach the EC2 instance"
  type        = string
}

variable "target_port" {
  description = "Port on which the instance should receive traffic"
  type        = number
}
