output "dynamodb_name" {
  value = aws_dynamodb_table.fhir_api_db.name
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.fhir_api_db.arn
}

output "dynamodb_cmk_arn" {
  value = aws_kms_key.fhir_api_db_key.arn
}

output "base_url" {
  value = aws_api_gateway_deployment.fhir_server.invoke_url
}

output "user_pool_id" {
  value = aws_cognito_user_pool.api_pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.api_pool_client.id
}

output "dev_key" {
  value = aws_api_gateway_api_key.developer_key.value
}