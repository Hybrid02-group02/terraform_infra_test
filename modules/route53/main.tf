# Route 53 Hosted Zone 생성
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# 루트 도메인 A 레코드 생성
resource "aws_route53_record" "root_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# 서브도메인(www.~) A 레코드 생성
resource "aws_route53_record" "www_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}" # www.naddong.shop
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
