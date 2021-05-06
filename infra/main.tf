module "vpc" {
  source = "./modules/vpc"
  prefix = local.prefix
  region = var.region
}

module "s3" {
  source = "./modules/s3"
  prefix = local.prefix
  region = var.region
  stage  = var.stage

  lake_subnet = module.vpc.lake_subnet
}

module "api" {
  source = "github.com/spe-uob/HealthcareLakeAPI.git"

  stage  = var.stage
  region = var.region
  prefix = local.prefix
}

module "etl" {
  source = "github.com/spe-uob/HealthcareLakeETL.git"

  region = var.region
  prefix = local.prefix
}

module "glue" {
  source = "./modules/glue"

  glue_script_bucket_id = module.etl.s3_bucket_name
  glue_script_path      = module.etl.script_path
  glue_library_path     = module.etl.library_path
  etl_bucket_arn        = module.etl.bucket_arn

  lake_arn  = module.s3.bucket_arn
  lake_name = module.s3.bucket_name

  fhir_db_name = module.api.dynamodb_name
  fhir_db_arn  = module.api.dynamodb_arn
  fhir_db_cmk  = module.api.dynamodb_cmk_arn

  prefix = local.prefix
  stage  = var.stage
}

locals {
  // resource naming prefix
  prefix = var.project_name
  // resource tagging
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project_name
    # Owner       = var.devops_contact
    ManagedBy = "Terraform"
  }
}
