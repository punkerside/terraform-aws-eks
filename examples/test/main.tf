module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.6"
}

module "eks" {
  source = "../../"

  endpoint_public_access = true
  subnet_private_ids     = module.vpc.subnet_private_ids.*.id
  subnet_public_ids      = module.vpc.subnet_public_ids.*.id
}