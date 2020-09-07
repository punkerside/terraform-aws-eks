# Terraform Module - EKS

[![Open Source Helpers](https://www.codetriage.com/punkerside/terraform-aws-eks/badges/users.svg)](https://www.codetriage.com/punkerside/terraform-aws-eks)
[![GitHub Issues](https://img.shields.io/github/issues/punkerside/terraform-aws-eks.svg)](https://github.com/punkerside/terraform-aws-eks/issues)
[![GitHub Tag](https://img.shields.io/github/tag-date/punkerside/terraform-aws-eks.svg?style=plastic)](https://github.com/punkerside/terraform-aws-eks/tags/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Kubernetes es un software de código abierto que le permite implementar y administrar aplicaciones en contenedores a escala. Kubernetes administra clústeres de instancias de informática de Amazon EC2 y ejecuta contenedores en ellas con procesos destinados a implementación, mantenimiento y escalado.

## AWS Resources

* Elastic Container Service for Kubernetes (EKS)
* EC2 Auto Scaling
* Identity and Access Management (IAM)

## Usage

```hcl
module "vpc" {
  source     = "punkerside/vpc/eks"
  version    = "0.0.1"

  project    = "falcon"
  env        = "sandbox"
}
```

## Examples

* [Basic](https://github.com/punkerside/terraform-aws-eks/tree/master/examples/basic)
* [Full](https://github.com/punkerside/terraform-aws-eks/tree/master/examples/full)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Tests

1. Install [rvm](https://rvm.io/rvm/install) and the ruby version specified in the [Gemfile](https://github.com/punkerside/terraform-aws-eks/tree/master/Gemfile).
2. Install bundler and the gems from our Gemfile:
```
gem install bundler
bundle install
```
3. Test using `bundle exec kitchen test` from the root of the repo.

## Authors

The module is maintained by [Ivan Echegaray](https://github.com/punkerside)

## License

Apache 2 Licensed. See LICENSE for full details.