resource "local_file" "artifact_api_user" {
    source  = "../api/cmd/user/bin/lambda.zip"
    filename = "../api/cmd/user/bin/lambda.zip"
}

resource "aws_s3_bucket_object" "artifact_api_user" {
    bucket = aws_s3_bucket.artifacts.id
    key = local_file.artifact_api_user.filename
    source = local_file.artifact_api_user.filename
    etag = "${md5(file("${local_file.artifact_api_user.filename}"))}"
}

resource "aws_lambda_function" "api_user" {
  function_name = "${local.service_name}_api_user"

  role = aws_iam_role.lambda_exec.arn

  package_type = "Zip"
  runtime="go1.x"
  handler = "lambda"

  s3_bucket = aws_s3_bucket.artifacts.id
  s3_key = "${aws_s3_bucket_object.artifact_api_user.key}"
  s3_object_version = "${aws_s3_bucket_object.artifact_api_user.version_id}"
  
}

resource "aws_cloudwatch_log_group" "api_user" {
  name = "/aws/lambda/${aws_lambda_function.api_user.function_name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "api_user" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.api_user.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "GET"
}

resource "aws_apigatewayv2_route" "api_user" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /user"
  target    = "integrations/${aws_apigatewayv2_integration.api_user.id}"
}

resource "aws_lambda_permission" "api_gw_api_user" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_user.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}