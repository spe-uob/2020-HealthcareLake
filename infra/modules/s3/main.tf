/*
  The 'Lake' is an S3 bucket with our
  Parquet files stored in
*/
resource "aws_s3_bucket" "lake" {
  bucket = "${var.prefix}-lake"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.prefix}-lake-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "lake" {
  bucket = aws_s3_bucket.lake.id

  policy = data.aws_iam_policy_document.lake_vpc.json
}

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

resource "aws_s3_bucket" "fhir_log_bucket" {
  bucket = "${var.prefix}-fhir-binary-logs"
  acl    = "log-delivery-write"
}

resource "aws_kms_key" "fhir_binary_key" {
  description   = "KMS key for FHIR Binary S3"
}

resource "aws_kms_alias" "fhir_binary_key_alias" {
  name          = "alias/fhirS3Key-${var.stage}"
  target_key_id = aws_kms_key.fhir_binary_key.key_id
}

resource "aws_ssm_parameter" "s3_binary_arn" {
  name  = "/bucket/fhir-binary/arn"
  description = "S3 FHIR Binary ARN"
  type = "SecureString"
  value = aws_s3_bucket.fhir_binary.arn
}

resource "aws_ssm_parameter" "s3_binary_kms_arn" {
  name  = "/kms/fhir-binary/arn"
  description = "S3 FHIR Binary KMS ARN"
  type = "SecureString"
  value = aws_kms_key.fhir_binary_key.arn
}