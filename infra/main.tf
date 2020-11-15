terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
  // where our terraform state is stored
  backend "s3" {
    bucket  = "data-lake-devops-tfstate"
    key     = "data-lake.tfstate"
    region  = "eu-west-2"
    encrypt = true
    // include a state lock to prevent deployment conflicts
    dynamodb_table = "data-lake-devops-tfstate-lock"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_kms_key" "thekey" {
  description = "Key used to encrypt bucket objects"
}

resource "aws_s3_bucket" "data_lake_s3" {
  bucket = "healthcare-datalake"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.thekey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

locals {
  // resource naming prefix
  prefix = "${var.prefix}-${terraform.workspace}"
  // resource tagging
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}
