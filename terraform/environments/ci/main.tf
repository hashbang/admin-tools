terraform {
    backend "s3" {
        bucket = "hashbang-terraform-ci"
        key = "state.tfstate"
        region = "us-west-2"
        lock_table = "hashbang-terraform-ci"
    }
}

provider "aws" {
    region = "us-west-2"
}

module "vpc" {
    source = "github.com/terraform-community-modules/tf_aws_vpc?ref=v1.0.6"
    name = "ci"
    cidr = "10.0.0.0/16"
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
    azs = ["us-west-2a", "us-west-2b"]
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
}
