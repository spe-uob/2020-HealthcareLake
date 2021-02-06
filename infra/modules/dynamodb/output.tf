output "name" {
  value = aws_dynamodb_table.fhir_api_db.name
}

output "arn" {
  value = aws_dynamodb_table.fhir_api_db.arn
}

output "cmk_arn" {
  value = aws_kms_key.fhir_api_db_key.arn
}