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
