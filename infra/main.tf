terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  prefix = "${var.prefix}-${terraform.workspace}"
  region = local.region
}

module "s3" {
  source      = "./modules/s3"
  prefix      = "${var.prefix}-${terraform.workspace}"
  region      = local.region
  lake_subnet = module.vpc.lake_subnet
  stage       = var.stage
}

module "api" {
  source = "github.com/spe-uob/HealthcareLakeAPI.git"

  username = var.username
  password = var.password
  stage    = var.stage
  region   = local.region
}

module "etl" {
  source = "github.com/spe-uob/HealthcareLakeETL.git"

  region = local.region
  prefix = local.prefix
}

module "glue" {
  source                = "./modules/glue"
  glue_script_bucket_id = module.etl.s3_bucket_name
  glue_script_path      = module.etl.script_path
  lake_bucket           = module.s3.bucket_id
  fhir_db_name          = module.api.dynamodb_name
  fhir_db_arn           = module.api.dynamodb_arn
  fhir_db_cmk           = module.api.dynamodb_cmk_arn
  prefix                = local.prefix

  depends_on = [
    module.etl,
  ]
}

locals {
  region = var.region
  // resource naming prefix
  prefix = "${var.prefix}-${terraform.workspace}"
  // resource tagging
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    # Owner       = var.devops_contact
    ManagedBy = "Terraform"
  }
}
