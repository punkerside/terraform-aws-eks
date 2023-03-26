# Terraform Module - EKS

[![Build](https://github.com/punkerside/terraform-aws-eks/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/punkerside/terraform-aws-eks/actions/workflows/main.yml)
[![Open Source Helpers](https://www.codetriage.com/punkerside/terraform-aws-eks/badges/users.svg)](https://www.codetriage.com/punkerside/terraform-aws-eks)
[![GitHub Issues](https://img.shields.io/github/issues/punkerside/terraform-aws-eks.svg)](https://github.com/punkerside/terraform-aws-eks/issues)
[![GitHub Tag](https://img.shields.io/github/tag-date/punkerside/terraform-aws-eks.svg?style=plastic)](https://github.com/punkerside/terraform-aws-eks/tags/)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/punkerside/terraform-aws-eks)

## Usage

```hcl
module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.4"
}

module "eks" {
  source  = "punkerside/eks/aws"
  version = "0.0.1"

  subnet_private_ids = module.vpc.subnet_private_ids.*.id
  subnet_public_ids  = module.vpc.subnet_public_ids.*.id
}
```

## Examples

* [Basic](https://github.com/punkerside/terraform-aws-eks/tree/main/examples/basic)
* [Full](https://github.com/punkerside/terraform-aws-eks/tree/main/examples/full)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.19 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.subnet_private_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.subnet_public_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2RoleforSSM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AutoScalingFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_string.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | Tipo de AMI de los nodos | `string` | `"AL2_x86_64"` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Tipo de capacidad asociada con el grupo de nodos de EKS | `string` | `"SPOT"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Numero deseado de nodos | `string` | `2` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Tamaño de disco asociado a los nodos | `string` | `120` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Version de Kubernetes | `string` | `"1.25"` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Acceso privado al Control plane | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Acceso publico al Control plane | `bool` | `true` | no |
| <a name="input_force_update_version"></a> [force\_update\_version](#input\_force\_update\_version) | Actualizacion automatica de la version de Kubernetes | `bool` | `false` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipo de instancia de los nodos | `list(string)` | <pre>[<br>  "r5a.large"<br>]</pre> | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Numero maximo de nodos | `string` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Numero minimo de nodos | `string` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Nombre asignado a todos los recursos creados por esta plantilla. | `string` | `null` | no |
| <a name="input_subnet_private_ids"></a> [subnet\_private\_ids](#input\_subnet\_private\_ids) | Ids de redes privadas | `list(string)` | n/a | yes |
| <a name="input_subnet_public_ids"></a> [subnet\_public\_ids](#input\_subnet\_public\_ids) | Ids de redes publicas | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Etiquetas asignadas a todos los recursos creados por esta plantilla. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main"></a> [main](#output\_main) | EKS values |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Tests

1. Install [rvm](https://rvm.io/rvm/install) and the ruby version specified in the [Gemfile](https://github.com/punkerside/terraform-aws-eks/tree/main/Gemfile).
2. Install bundler and the gems from our Gemfile:
```
gem install bundler
bundle install
```
3. Test using `bundle exec kitchen test` from the root of the repo.

## Authors

The module is maintained by [Ivan Echegaray](https://github.com/punkerside)