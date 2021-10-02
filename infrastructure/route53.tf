data aws_route53_zone "ecommerce" {
  name = var.domain_name
}

resource "aws_route53_record" "frontend_apex" {
  zone_id = data.aws_route53_zone.ecommerce.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.ecommerce_frontend_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.ecommerce_frontend_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource aws_route53_record "api" {
  zone_id = data.aws_route53_zone.ecommerce.id
  name    = "api.${var.domain_name}"
  type    = "A"
  alias {
    name                   = module.api_gateway.apigatewayv2_domain_name_configuration[0].target_domain_name
    zone_id                = module.api_gateway.apigatewayv2_domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }

}

resource "aws_route53_record" "frontend_www" {
  zone_id = data.aws_route53_zone.ecommerce.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  records = [aws_cloudfront_distribution.ecommerce_frontend_cdn.domain_name]
  ttl     = 300
}
