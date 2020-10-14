provider "aws" {
  region = "us-east-1"
}

# dependencia
module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.8"

  project = "falcon"
  env     = "sandbox"
}
# dependencia

module "eks" {
  source  = "punkerside/eks/aws"
  version = "0.0.4"

  project                 = "falcon"
  env                     = "awspec"
  eks_version             = "1.18"
  desired_size            = 4
  max_size                = 10
  min_size                = 2
  instance_types          = ["r5a.large"]
  disk_size               = 100
  ami_type                = "AL2_x86_64"
  force_update_version    = true
  endpoint_private_access = false
  endpoint_public_access  = true
  subnet_private_ids      = module.vpc.subnet_private_ids
  subnet_public_ids       = module.vpc.subnet_public_ids
}