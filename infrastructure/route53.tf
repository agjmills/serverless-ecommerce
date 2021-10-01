resource "aws_route53_record" "api" {
  name = module.api_gateway.apigatewayv2_domain_name_target_domain_name
  type = "A"
  zone_id = aws_route53_zone.ecommerce.id

  alias {
    name = module.api_gateway.apigatewayv2_domain_name_target_domain_name
    zone_id = module.api_gateway.apigatewayv2_domain_name_hosted_zone_id
    evaluate_target_health = false
  }
}

resource aws_route53_zone "ecommerce" {
  name = var.domain_name
  lifecycle {
    prevent_destroy = true
  }
}