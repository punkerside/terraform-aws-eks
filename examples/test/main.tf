provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.4"
}

module "eks" {
  source = "../../"

  subnet_private_ids = module.vpc.subnet_private_ids.*.id
  subnet_public_ids  = module.vpc.subnet_public_ids.*.id
}