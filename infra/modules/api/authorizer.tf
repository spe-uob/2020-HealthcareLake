resource "aws_api_gateway_authorizer" "proxy" {
  name = "CognitoUserPoolAuthorizer"
  type = "COGNITO_USER_POOLS"
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  provider_arns = [aws_cognito_user_pool.api_pool.arn]
}