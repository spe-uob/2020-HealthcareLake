resource "aws_kms_key" "fhir_api_db_key" {
  description   = "KMS key for DynamoDB"
}

resource "aws_kms_alias" "fhir_api_db_key" {
  name          = "alias/fhirDbKey-${var.stage}"
  target_key_id = aws_kms_key.fhir_api_db_key.key_id
}

resource "aws_dynamodb_table" "fhir_api_db" {
  name    = "fhir-db-${var.stage}"
  billing_mode = "PAY_PER_REQUEST"
  
  hash_key = "id"
  range_key = "vid"
  
  attribute {
    name  = "id"
    type = "S"
  }
  attribute {
    name  = "vid"
    type  = "N"
  }

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption {
    enabled  = true
    kms_key_arn = aws_kms_key.fhir_api_db_key.arn
  }

  tags = {
    "service" = "fhir"
  }
}

resource "aws_ssm_parameter" "endpoint" {
  name  = "/database/${aws_dynamodb_table.fhir_api_db.name}/endpoint"
  description = "Endpoint to connect to the fhir dynamodb"
  type = "SecureString"
  value = aws_dynamodb_table.fhir_api_db.arn
}