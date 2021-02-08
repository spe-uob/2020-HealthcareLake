/*
  FHIR Lambda Role
*/
data "aws_iam_policy_document" "lambda_role_policy" {
  // Allow decrypting DynamoDB and S3
  statement {
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext"
    ]
    effect = "Allow"
    resources = [
      aws_kms_key.fhir_binary_key.arn,
      aws_kms_key.fhir_api_db_key.arn
    ]
  }
  // Allow CRUD on DynamoDB
  statement {
    actions = [
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem"
    ]
    effect = "Allow"
    resources = [
      aws_dynamodb_table.fhir_api_db.arn
    ]
  }
  
  statement {
    actions = ["s3:*"]
    effect = "Allow"
    resources = [
      aws_s3_bucket.fhir_binary.arn,
      "${aws_s3_bucket.fhir_binary.arn}/*"
    ]
  }

  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

/*
  S3 Https-Only policy
*/
data "aws_iam_policy_document" "s3_https_only" {
  statement {
    sid = "AllowSSLRequestsOnly"

    effect = "Deny"

    principals {
       type = "*"
       identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.fhir_binary.arn,
      "${aws_s3_bucket.fhir_binary.arn}/*"
    ]

    condition {
      test  = "Bool"
      variable = "aws:SecureTransport"
      values = [false]
    }
  }
}
