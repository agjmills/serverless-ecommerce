resource "aws_cognito_user_pool" "ecommerce-userpool" {
  name = "${var.domain_name}-users"
}

resource "aws_cognito_user_pool_client" "frontend_app_client" {
  name = "${var.domain_name}-frontend"
  user_pool_id = aws_cognito_user_pool.ecommerce-userpool.id
  supported_identity_providers = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["implicit"]
  callback_urls = ["http://localhost:3000/authorize", "https://${var.domain_name}/authorize"]
  logout_urls = ["http://localhost:3000/logout", "https://${var.domain_name}/logout"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
}

