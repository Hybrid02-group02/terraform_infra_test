output "route53_zone_id" {
  description = "The ID of the created Route 53 Hosted Zone"
  value       = aws_route53_zone.main.zone_id
}

output "root_record_name" {
  description = "The root domain record (A 레코드)"
  value       = aws_route53_record.root_record.name
}

output "www_record_name" {
  description = "The www subdomain record (A 레코드)"
  value       = aws_route53_record.www_record.name
}
