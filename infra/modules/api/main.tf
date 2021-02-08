resource "aws_lambda_function" "fhir_server" {
  function_name = "FhirServer"

  s3_bucket = var.deployment_bucket
  s3_key = "v1.0.0/lambda.zip"

  handler = "index.default"
  runtime = "nodejs12.x"

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      API_URL = "",
      S3_KMS_KEY = aws_kms_key.fhir_binary_key.key_id,
      RESOURCE_TABLE = aws_dynamodb_table.fhir_api_db.name,
      FHIR_BINARY_BUCKET = aws_s3_bucket.fhir_binary.id,
      OAUTH2_DOMAIN_ENDPOINT = ""
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

