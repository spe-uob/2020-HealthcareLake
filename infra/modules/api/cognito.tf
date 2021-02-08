/*
  Cognito user pool:
    - Practitioner
    - Non-practitioner
    - Auditor
*/

resource "aws_cognito_user_pool" "api_pool" {
  name = "api_user_pool"

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    name = "email"
    required = true
  }

  schema {
    attribute_data_type = "String"
    name = "cc_confirmed"
  }
}

resource "aws_cognito_user_pool_client" "api_pool_client" {
  name = "api_user_pool_client"

  user_pool_id = aws_cognito_user_pool.api_pool.id

  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = ["email", "openid", "profile"]

  callback_urls = ["http://localhost"]
  default_redirect_uri = "http://localhost"

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]

  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_domain" "api_pool_domain" {
  domain = aws_cognito_user_pool_client.api_pool_client.id
  user_pool_id = aws_cognito_user_pool.api_pool.id
}

resource "aws_cognito_user_group" "practitioner" {
  name = "practitioner"
  description = "This is a member of the hospital staff, who directly helps patients"
  precedence = 0
  user_pool_id = aws_cognito_user_pool.api_pool.id
}

resource "aws_cognito_user_group" "non_practicioner" {
  name = "non-practitioner"
  description = "This is a member of the hospital staff who needs access to non-medical record"
  precedence = 1
  user_pool_id = aws_cognito_user_pool.api_pool.id
}

resource "aws_cognito_user_group" "auditor" {
  name = "auditor"
  description = "Someone who needs read, v_read and search access on patients"
  precedence = 2
  user_pool_id = aws_cognito_user_pool.api_pool.id
}