provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.6"

  project = "falcon"
  env     = "sandbox"
}

module "eks" {
  source  = "punkerside/vpc/eks"
  version = "0.0.1"

  project              = "falcon"
  env                  = "sandbox"
  eks_version          = "1.17"
  desired_size         = 2
  max_size             = 4
  min_size             = 1
  instance_types       = ["r5a.large"]
  force_update_version = true
  disk_size            = 80
  ami_type             = "AL2_x86_64"
  subnet_private_ids   = module.vpc.subnet_private_ids
  subnet_public_ids    = module.vpc.subnet_public_ids
}