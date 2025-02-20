resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = "arn:aws:iam::123456789012:role/LambdaRole"

  filename      = "lambda_function_payload.zip"
}
