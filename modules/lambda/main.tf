

# 1. Packaging Lambda Code
# This resource prepares the package to be uploaded to AWS by zipping the Python file.
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_code/handler.py"
  output_path = "lambda_code/handler.zip"
}

# 2. Lambda Function Definition
resource "aws_lambda_function" "data_processor" {
  function_name = "${var.project}-${var.env}-${var.lambda_function_name}"

  # getting the package from local
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # role assingment created in IAM module. 
  role    = var.lambda_execution_role_arn
  handler = "handler.lambda_handler"
  runtime = var.lambda_runtime # python3.11 by default
  timeout = var.lambda_timeout # 60 second by default

  # Environment Variables declaration that is used in Lambda function).
  environment {
    variables = {
      # Target Bucket is the 'processed-data-bucket' module output's name
      TARGET_BUCKET_NAME = "${var.dest_bucket_name}"
    }
  }
}

# 3.  Trigger S3 Declaration
# This triggers Lambda when an object is uploaded to the ‘raw-data-bucket’.
resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = var.source_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.data_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  # add this dependency explicitly to ensure that the Lambda function and all its
  # associated policies and permissions (like the aws_lambda_permission resource) 
  # are fully created and stable before the S3 notification is set.
  depends_on = [
    aws_lambda_function.data_processor
  ]
}


# 4. Permission to Allow Lambda to Trigger from S3 Tracker
resource "aws_lambda_permission" "s3_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processor.function_name
  principal     = "s3.amazonaws.com"

  # Only allow triggering by this bucket (raw-data-bucket).
  source_arn = var.source_bucket_arn

  # Establishes Explicit  dependency between Notification and Lambda Function.
  depends_on = [
    aws_s3_bucket_notification.s3_trigger
  ]
}