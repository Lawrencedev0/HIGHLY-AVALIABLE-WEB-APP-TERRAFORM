output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_app_subnets" {
  value = aws_subnet.app[*].id
}

output "private_db_subnets" {
  value = aws_subnet.db[*].id
}

output "load_balancer_dns" {
  description = "Open this address to test the web application."
  value       = "http://${aws_lb.app.dns_name}"
}

output "load_balancer_hostname" {
  value = aws_lb.app.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "rds_port" {
  value = aws_db_instance.postgres.port
}

output "s3_bucket_name" {
  value = aws_s3_bucket.static.bucket
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.static.domain_name
}

output "route53_record" {
  value = var.domain_name == null ? null : var.domain_name
}
