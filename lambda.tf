data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../python/lambda/"
  output_path = "${path.module}/lambda/lambda_function_payload.zip"
}

resource "aws_lambda_function" "example" {
  function_name = "sample_0717_lambda"

  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"

  runtime = "python3.8"
}

# Define Auth Challenge
resource "aws_lambda_function" "define_auth_challenge" {
  function_name = "define_auth_challenge_lambda"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

# Create Auth Challenge
resource "aws_lambda_function" "create_auth_challenge" {
  function_name = "create_auth_challenge_lambda"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  environment {
    variables = {
      SENDER_EMAIL = var.sender_email
    }
  }
}

# Verify Auth Challenge
resource "aws_lambda_function" "verify_auth_challenge_response" {
  function_name = "verify_auth_challenge_response_lambda"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "custom_message" {
  function_name = "custom_message_lambda"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "pre_authentication" {
  function_name = "pre_authentication_lambda"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"
  
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/${aws_api_gateway_method.example.http_method}/sample_0717_api"
}

