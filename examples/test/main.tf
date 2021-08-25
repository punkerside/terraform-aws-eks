provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.8"

  project = "falcon"
  env     = "awspec"
}

module "eks" {
  source = "../../"

  subnet_private_ids = module.vpc.subnet_private_ids
  subnet_public_ids  = module.vpc.subnet_public_ids
}