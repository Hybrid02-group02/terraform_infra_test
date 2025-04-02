resource "aws_wafv2_web_acl" "main" {
  name        = "${var.project_name}-${var.name}-waf"
  description = "Web ACL for ${var.project_name} ${var.environment}"
  scope       = var.scope  # REGIONAL (ALB), CLOUDFRONT

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-${var.name}-waf-metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-${var.name}-waf-common"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# ALB에 WAF Web ACL 연결
resource "aws_wafv2_web_acl_association" "alb" {
  count              = var.associate_alb ? 1 : 0
  resource_arn       = var.alb_arn
  web_acl_arn        = aws_wafv2_web_acl.main.arn
  depends_on         = [aws_wafv2_web_acl.main]
}

