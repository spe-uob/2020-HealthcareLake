terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22"
    }
  }
  backend "s3" {
    key            = "data-lake.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  prefix = "${var.prefix}-${terraform.workspace}"
  region = var.region
}

module "s3" {
  source      = "./modules/s3"
  prefix      = "${var.prefix}-${terraform.workspace}"
  region      = var.region
  lake_subnet = module.vpc.lake_subnet
  stage       = var.stage
}

module "api" {
  source            = "./modules/api"
  stage             = var.stage
  region            = var.region
  prefix            = local.prefix
  deployment_bucket = var.deployment_bucket
}



# module "glue" {
#   source       = "./modules/glue"
#   lake_bucket  = module.s3.bucket_arn
#   fhir_db_name = module.api.dynamodb_name
#   fhir_db_arn  = module.api.dynamodb_arn
#   fhir_db_cmk  = module.api.dynamodb_cmk_arn
#   prefix       = local.prefix
# }

locals {
  // resource naming prefix
  prefix = "${var.prefix}-${terraform.workspace}"
  // resource tagging
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.devops_contact
    ManagedBy   = "Terraform"
  }
}
