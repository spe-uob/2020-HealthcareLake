resource "aws_lambda_function" "fhir_server" {
  function_name = "FhirServer"

  s3_bucket = var.deployment_bucket
  s3_key = "v1.0.0/lambda.zip"

  handler = "index.default"
  runtime = "nodejs12.x"

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      API_URL = "https://${aws_api_gateway_rest_api.fhir_server_gw.id}.execute-api.${var.region}.amazonaws.com/${var.stage}",
      S3_KMS_KEY = aws_kms_key.fhir_binary_key.key_id,
      RESOURCE_TABLE = aws_dynamodb_table.fhir_api_db.name,
      FHIR_BINARY_BUCKET = aws_s3_bucket.fhir_binary.id,
      OAUTH2_DOMAIN_ENDPOINT = "https://${aws_cognito_user_pool_domain.api_pool_domain.domain}.auth.${var.region}.amazoncognito.com/oauth2"
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

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  parent_id = aws_api_gateway_rest_api.fhir_server_gw.root_resource_id
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.proxy.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.fhir_server_gw.id
   resource_id   = aws_api_gateway_rest_api.fhir_server_gw.root_resource_id
   http_method = "ANY"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.proxy.id

    request_parameters = {
      "method.request.path.proxy" = true
    }
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fhir_server.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.fhir_server_gw.execution_arn}/*/*"
}