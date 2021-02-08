resource "aws_kms_key" "fhir_api_db_key" {
  description   = "KMS key for DynamoDB"
}

resource "aws_kms_key" "fhir_binary_key" {
  description   = "KMS key for FHIR Binary S3"
}