# Dev
# terraform {
#   backend "s3" {
#     bucket  = "dev-onzoom-terraform-backend-store"
#     encrypt = true
#     key     = "onzoom2/onzoom_efs.tfstate"
#     region  = "us-east-1"
#   }
# }

# Prod
terraform {
  # required_providers {
  #   aws = {
  #     source  = "hashicorp/aws"
  #     version = "~> 4.16.0"
  #   }
  # }
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket     = "onzoom-terraform-backend-store"
    encrypt    = true
    kms_key_id = "9d75acb0-fc56-4d82-99d0-b42d25d3ce95"
    key        = "onzoom2/zemonitoring_efs.tfstate"
    region     = "us-east-1"
  }
}

# Defining AWS provider
provider "aws" {
  alias  = "go-va"
  region = lookup(var.aws_region, terraform.workspace, "go")
}

# Defining AWS provider
provider "aws" {
  alias  = "eu-ff"
  region = lookup(var.aws_region, terraform.workspace, "eu01")
}
