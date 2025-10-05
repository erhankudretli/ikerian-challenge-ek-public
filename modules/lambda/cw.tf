# 1. CloudWatch Log Group Resource
# Lambda expect Log Group same name as the Lambda function.
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.data_processor.function_name}"
  retention_in_days = var.log_retention_days # 7 days by default
}