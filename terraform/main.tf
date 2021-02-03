terraform {
  backend "s3" {
    bucket = "hashbang-terraform"
    key    = "state.tfstate"
    region = "us-west-2"
    dynamodb_table = "hashbang-terraform"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}

variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region     = var.region
}

module "r53" {
  source = "./modules/r53"
}

module "podcast" {
  source = "./modules/podcast"
}
