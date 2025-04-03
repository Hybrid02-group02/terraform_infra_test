resource "aws_lb" "main" { # ALB 리소스 생성
  name               = "${var.project_name}-${var.name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name        = "${var.project_name}-${var.name}-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "main" { # 타겟 그룹
  name     = "${var.project_name}-${var.name}-tg"
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
  }

  tags = {
    Name        = "${var.project_name}-${var.name}-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" { # HTTP 리스너
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
