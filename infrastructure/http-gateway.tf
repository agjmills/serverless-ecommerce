module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "api.${var.domain_name}-gateway"
  description   = "API Gateway for api.${var.domain_name}"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  domain_name                 = "api.${var.domain_name}"
  domain_name_certificate_arn = module.acm.acm_certificate_arn

  # Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.http_api_gateway_logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  tags = {
    Name = "http-apigateway"
  }
}


resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id = module.api_gateway.apigatewayv2_api_id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name = "white-oak-soaps-api-authorizer"

  jwt_configuration {
    audience = [
      aws_cognito_user_pool_client.frontend_app_client.id
    ]
    issuer = "https://${aws_cognito_user_pool.ecommerce-userpool.endpoint}"
  }
}

resource aws_ssm_parameter "http_gateway_id" {
  name = "/${var.domain_name}/http-api-gateway-id"
  type = "String"
  value = module.api_gateway.apigatewayv2_api_id
  overwrite = true
}

resource aws_ssm_parameter "http_gateway_authorizer" {
  name = "/${var.domain_name}/http-api-gateway-authorizer-id"
  type = "String"
  value = aws_apigatewayv2_authorizer.cognito_authorizer.id
  overwrite = true
}