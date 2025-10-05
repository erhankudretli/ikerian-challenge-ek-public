
output "lambda_execution_role_name" {
  description = "Oluşturulan IAM Rolünün adı."
  value       = aws_iam_role.lambda_exec.name
}

output "lambda_execution_role_arn" {
  description = "Oluşturulan IAM Rolünün ARN'i (Lambda fonksiyonunda kullanılacak)."
  value       = aws_iam_role.lambda_exec.arn
}