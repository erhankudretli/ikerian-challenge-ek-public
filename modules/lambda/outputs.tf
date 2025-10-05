output "lambda_log_group_name" {
  description = "The CloudWatch Log Group where Lambda logs are stored."
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}
output "lambda_log_group_arn" {
  description = "The CloudWatch Log Group where Lambda logs are stored."
  value       = aws_cloudwatch_log_group.lambda_log_group.arn
}