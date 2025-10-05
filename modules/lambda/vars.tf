variable "env" {}
variable "owner" {}
variable "project" {}


variable "lambda_function_name" {
  description = "The name for the Lambda function."
  type        = string
  default     = "s3-data-processor"
}

variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
  default     = "python3.11"
}

variable "lambda_timeout" {
  description = "The maximum execution time (in seconds) for the lambda function."
  type        = number
  default     = 60
}

# The variable that determines which S3 bucket will be the trigger.
# In this case, we will use the ‘raw-data-bucket’ module.
variable "trigger_bucket_module" {
  description = "The name of the module that will serve as the S3 trigger source (e.g., 'raw-data-bucket')."
  type        = string
  default     = "raw-data-bucket"
}
variable "lambda_execution_role_arn" {}
variable "dest_bucket_name" {}
variable "source_bucket_name" {}
variable "source_bucket_arn" {}
variable "log_retention_days" {
  default = 7
}