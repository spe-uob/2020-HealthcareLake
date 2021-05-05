terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22"
    }
  }
}

provider "aws" {
  region = local.region
}

module "data_lake" {
  source       = "./infra"
  region       = local.region
  stage        = "dev"
  project_name = "healthcarelake"

  # providers = {
  #   aws = aws
  # }
}

locals {
  region = "eu-west-2"
}