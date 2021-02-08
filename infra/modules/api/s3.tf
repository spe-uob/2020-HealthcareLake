/*
  FHIR Binary bucket stores all unstructured FHIR
  resources from the API
*/
resource "aws_s3_bucket" "fhir_binary" {
  bucket = "${var.prefix}-fhir-binary"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.fhir_log_bucket.id
    target_prefix = "binary-acl"
  }

  // KMS encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.fhir_binary_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
resource "aws_s3_bucket_policy" "https_only_policy" {
  bucket = aws_s3_bucket.fhir_binary.id
  policy = data.aws_iam_policy_document.s3_https_only.json
}

// Logs
resource "aws_s3_bucket" "fhir_log_bucket" {
  bucket = "${var.prefix}-fhir-binary-logs"
  acl    = "log-delivery-write"
}