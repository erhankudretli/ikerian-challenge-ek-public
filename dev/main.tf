############
# S3 Bucket module that creates object storage bucket for raw data  
############
module "raw-data-bucket" {
  source      = "../modules/s3"
  bucket_name = "${var.project}-${var.env}-raw-data-bucket"
}
############
# S3 Bucket module that creates an object storage bucket for extracted data  
############
module "processed-data-bucket" {
  source      = "../modules/s3"
  bucket_name = "${var.project}-${var.env}-processed-data-bucket"
}
############
# IAM policies and roles for Lambda Function
############
module "iam" {
  source               = "../modules/iam"
  env                  = var.env
  owner                = var.owner
  project              = var.owner
  source_bucket_arn    = module.raw-data-bucket.bucket_arn
  dest_bucket_arn      = module.processed-data-bucket.bucket_arn
  lambda_log_group_arn = module.lambda.lambda_log_group_arn
}
############
# Lambda Module for Data Extraction
############
module "lambda" {
  source                    = "../modules/lambda"
  env                       = var.env
  owner                     = var.owner
  project                   = var.owner
  lambda_execution_role_arn = module.iam.lambda_execution_role_arn
  dest_bucket_name          = module.processed-data-bucket.bucket_name
  source_bucket_name        = module.raw-data-bucket.bucket_name
  source_bucket_arn         = module.raw-data-bucket.bucket_arn
}

############
# S3 Bucket module that creates an object storage bucket for extracted data  
############
module "test-data-bucket" {
  source      = "../modules/s3"
  bucket_name = "${var.project}-${var.env}-test-data-bucket"
}