provider "aws" {
  region = "ap-northeast-2"
}

# VPC
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

# 보안 그룹 - EC2용 (SSH, HTTP)
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# ROSA
module "rosa" {
  source             = "../../modules/rosa"
  cluster_name       = var.cluster_name
  region             = var.region
  rosa_subnet_ids    = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)
  ec2_subnet_id      = module.vpc.public_subnet_ids[0]
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  instance_type      = var.rosa_instance_type
  key_name           = var.key_name
  enable_autoscaling = var.enable_autoscaling
  min_replicas       = 2
  max_replicas       = 4
  rosa_token         = var.rosa_token
  oidc_config_path   = "${path.root}/personal/modules/rosa/oidc_config_id.txt"
  redhat_url_path    = "${path.root}/personal/modules/rosa/details_page_url.txt"
}


# S3
module "s3" {
  source              = "../../modules/s3"
  project_name        = var.project_name
  name                = "static-assets"
  environment         = var.environment
  versioning_enabled  = true
  enable_sse          = true
  force_destroy       = true
}

# 보안 그룹 - ALB용
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# ALB
module "alb" {
  source                    = "../../modules/alb"
  project_name              = var.project_name
  name                      = "app"
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.public_subnet_ids
  security_group_ids        = [aws_security_group.alb_sg.id]
  target_port               = 80
  target_protocol           = "HTTP"
  health_check_path         = "/"
  health_check_protocol     = "HTTP"
  enable_deletion_protection = false
  internal                  = false
}


# route 53
module "route53" {
  source      = "../../modules/route53"
  
  domain_name  = var.route53_domain_name            # 가비아에서 등록한 도메인
  alb_dns_name = module.alb.alb_dns_name            # ALB DNS 이름
  alb_zone_id  = module.alb.alb_zone_id             # ALB Hosted Zone ID

  depends_on = [module.alb]
}

# waf
module "waf" {
  source         = "../../modules/waf"
  project_name   = var.project_name
  name           = "web"
  environment    = var.environment
  scope          = "REGIONAL"
  alb_arn        = module.alb.alb_arn
  associate_alb  = true
}


