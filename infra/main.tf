terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22"
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
  region  = var.region
}

module "vpc" {
  source = "./modules/vpc"
  prefix = "${var.prefix}-${terraform.workspace}"
  region = var.region
}

module "s3" {
  source = "./modules/s3"
  prefix  = "${var.prefix}-${terraform.workspace}"
  region = var.region
  lake_subnet = module.vpc.lake_subnet
}

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
