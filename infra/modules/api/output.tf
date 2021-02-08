output "dynamodb_name" {
  value = aws_dynamodb_table.fhir_api_db.name
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.fhir_api_db.arn
}

output "dynamodb_cmk_arn" {
  value = aws_kms_key.fhir_api_db_key.arn
}