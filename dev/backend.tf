terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "ek-eu-west-01-tf-state-bucket"
    key            = "env/dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"

  default_tags {
    tags = {
      env       = "dev"
      owner     = "ek"
      project   = "ikerian"
      ManagedBy = "Terraform"
    }
  }
}