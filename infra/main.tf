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
  region  = var.region
}