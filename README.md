# Terraform Module - EKS

[![Open Source Helpers](https://www.codetriage.com/punkerside/terraform-aws-eks/badges/users.svg)](https://www.codetriage.com/punkerside/terraform-aws-eks)
[![GitHub Issues](https://img.shields.io/github/issues/punkerside/terraform-aws-eks.svg)](https://github.com/punkerside/terraform-aws-eks/issues)
[![GitHub Tag](https://img.shields.io/github/tag-date/punkerside/terraform-aws-eks.svg?style=plastic)](https://github.com/punkerside/terraform-aws-eks/tags/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Usage

```hcl
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

  project            = "falcon"
  env                = "sandbox"
  subnet_private_ids = module.vpc.subnet_private_ids
  subnet_public_ids  = module.vpc.subnet_public_ids
}
```

## Examples

* [Basic](https://github.com/punkerside/terraform-aws-eks/tree/master/examples/basic)
* [Full](https://github.com/punkerside/terraform-aws-eks/tree/master/examples/full)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |
| aws | ~> 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_type | Ami type of nodes | `string` | `"AL2_x86_64"` | no |
| desired\_size | Number of nodes | `string` | `2` | no |
| disk\_size | Disk size of nodes | `string` | `80` | no |
| eks\_version | EKS version | `string` | `"1.18"` | no |
| endpoint\_private\_access | Endpoint private access | `bool` | `false` | no |
| endpoint\_public\_access | Endpoint public access | `bool` | `true` | no |
| env | Environment name | `string` | n/a | yes |
| force\_update\_version | Force update version | `bool` | `true` | no |
| instance\_types | Instance types | `list(string)` | <pre>[<br>  "r5a.large"<br>]</pre> | no |
| max\_size | Number max of nodes | `string` | `4` | no |
| min\_size | Number min of nodes | `string` | `1` | no |
| project | Project name | `string` | n/a | yes |
| subnet\_private\_ids | Ids of subnets private | `list(string)` | n/a | yes |
| subnet\_public\_ids | Ids of subnets public | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| values | EKS values |

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