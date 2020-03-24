terraform {
  required_version = "> 0.8.4"
  backend "s3" {
    bucket = "hashbang-terraform"
    key    = "state.tfstate"
    region = "us-west-2"
    lock_table = "hashbang-terraform"
  }
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
