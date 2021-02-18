resource "aws_api_gateway_rest_api" "fhir_server_gw" {
  name = "${var.prefix}-fhir-server"
  description = "FHIR Server API Gateway"
}

resource "aws_api_gateway_method_settings" "fhir_server" {
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  stage_name = var.stage
  method_path = "*/*"
  settings {
    logging_level = "INFO"
    data_trace_enabled = true
    metrics_enabled = true
  }
}

resource "aws_api_gateway_integration" "fhir_server" {
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.fhir_server.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.fhir_server.invoke_arn
}

resource "aws_api_gateway_stage" "fhir_server" {
  deployment_id = aws_api_gateway_deployment.fhir_server.id
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  stage_name = var.stage
  depends_on = [
    aws_api_gateway_deployment.fhir_server
  ]
}

resource "aws_api_gateway_deployment" "fhir_server" {
  depends_on = [
    aws_api_gateway_integration.fhir_server,
    aws_api_gateway_integration.lambda_root,
  ]
  stage_name = var.stage
  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan" "fhir_client" {
  name = "Fhir API Usage Plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.fhir_server_gw.id
    stage = aws_api_gateway_stage.fhir_server.stage_name
  }
  throttle_settings {
    burst_limit = 100
    rate_limit = 50
  }
}

resource "aws_api_gateway_api_key" "developer_key" {
  name = "developer-key-${var.stage}"
  description = "Key for developer to access the FHIR Api"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id = aws_api_gateway_api_key.developer_key.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.fhir_client.id
}