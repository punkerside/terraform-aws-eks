provider "aws" {
  region = "us-east-1"
}

# dependencia
module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.9"
}

module "eks" {
  source  = "punkerside/eks/aws"
  version = "0.0.5"

  subnet_private_ids = module.vpc.subnet_private_ids
  subnet_public_ids  = module.vpc.subnet_public_ids
}