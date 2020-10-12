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
  source  = "punkerside/vpc/eks"
  version = "0.0.1"

  project            = "falcon"
  env                = "awspec"
  subnet_private_ids = module.vpc.subnet_private_ids
  subnet_public_ids  = module.vpc.subnet_public_ids
}