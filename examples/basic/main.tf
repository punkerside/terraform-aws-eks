provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.6"
}

module "eks" {
  source             = "punkerside/vpc/eks"
  version            = "0.0.1"

  subnet_private_ids = module.vpc.subnet_private_ids
  subnet_public_ids  = module.vpc.subnet_public_ids
}