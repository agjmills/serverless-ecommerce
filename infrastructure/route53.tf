resource "aws_route53_record" "api" {
  name = module.api_gateway.apigatewayv2_domain_name_target_domain_name
  type = "A"
  zone_id = data.aws_route53_zone.ecommerce.id

  alias {
    name = module.api_gateway.apigatewayv2_domain_name_target_domain_name
    zone_id = module.api_gateway.apigatewayv2_domain_name_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "frontend_www" {
  zone_id = data.aws_route53_zone.ecommerce.id
  name = "www.${var.domain_name}"
  type = "CNAME"
  records = [aws_cloudfront_distribution.ecommerce_frontend_cdn.domain_name]
  ttl = 300
}

resource "aws_route53_record" "frontend_naked" {
  zone_id = data.aws_route53_zone.ecommerce.id
  name = var.domain_name
  type = "CNAME"
  records = [aws_cloudfront_distribution.ecommerce_frontend_cdn.domain_name]
  ttl = 300
}

data aws_route53_zone "ecommerce" {
  name = var.domain_name
}