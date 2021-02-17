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

resource "aws_api_gateway_deployment" "fhir_server" {
  depends_on = [
    aws_api_gateway_integration.fhir_server,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.fhir_server_gw.id
  stage_name = var.stage
}