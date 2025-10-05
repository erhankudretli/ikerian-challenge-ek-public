# --- IAM Role and Policy for Lambda Function---

# 1. IAM Role Declaration
# This role can only be assumed by the ‘lambda.amazonaws.com’ service thanks to ‘AssumeRolePolicy’.
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project}-${var.env}-lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# 2. IAM Policy Declaration 
# 
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.project}-${var.env}-s3-rw-policy"
  description = "Raw ve Processed S3 kovalarına okuma ve yazma yetkisi verir."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Destination (Processed) S3 Read/Write Permission 
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${var.dest_bucket_arn}", # comes from S3 module as an output
          "${var.dest_bucket_arn}/*",
        ]
      },
      # Source (Raw) S3 Read Permission 
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${var.source_bucket_arn}", # comes from S3 module as an output
          "${var.source_bucket_arn}/*",
        ]
      },
      # CloudWatch Permission
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${var.lambda_log_group_arn}:*" # comes from Lambda module as an output
      }
    ]
  })
}

# 3. Politikayı Role Bağlama
resource "aws_iam_role_policy_attachment" "s3_access_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}