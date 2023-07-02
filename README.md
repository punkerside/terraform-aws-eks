# Terraform Module - EKS

[![Build](https://github.com/punkerside/terraform-aws-eks/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/punkerside/terraform-aws-eks/actions/workflows/main.yml)
[![Open Source Helpers](https://www.codetriage.com/punkerside/terraform-aws-eks/badges/users.svg)](https://www.codetriage.com/punkerside/terraform-aws-eks)
[![GitHub Issues](https://img.shields.io/github/issues/punkerside/terraform-aws-eks.svg)](https://github.com/punkerside/terraform-aws-eks/issues)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=punkerside_terraform-aws-eks&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=punkerside_terraform-aws-eks)
[![GitHub Tag](https://img.shields.io/github/tag-date/punkerside/terraform-aws-eks.svg?style=plastic)](https://github.com/punkerside/terraform-aws-eks/tags/)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/punkerside/terraform-aws-eks)

## Usage

```hcl
module "vpc" {
  source  = "punkerside/vpc/aws"
  version = "0.0.6"
}

module "eks" {
  source  = "punkerside/eks/aws"
  version = "0.0.5"

  endpoint_public_access = true
  subnet_private_ids     = module.vpc.subnet_private_ids.*.id
  subnet_public_ids      = module.vpc.subnet_public_ids.*.id
}
```

## Examples

* [Basic](https://github.com/punkerside/terraform-aws-eks/tree/main/examples/basic)
* [Full](https://github.com/punkerside/terraform-aws-eks/tree/main/examples/full)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.0 |

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
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2RoleforSSM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AutoScalingFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_string.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | n/a | `string` | `"AL2_x86_64"` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | n/a | `string` | `"SPOT"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | n/a | `string` | `2` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | n/a | `string` | `120` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | n/a | `string` | `"1.27"` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | n/a | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | n/a | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | n/a | `bool` | `false` | no |
| <a name="input_force_update_version"></a> [force\_update\_version](#input\_force\_update\_version) | n/a | `bool` | `false` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | n/a | `list(string)` | <pre>[<br>  "r5a.large"<br>]</pre> | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `string` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `string` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `null` | no |
| <a name="input_subnet_private_ids"></a> [subnet\_private\_ids](#input\_subnet\_private\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet_public_ids"></a> [subnet\_public\_ids](#input\_subnet\_public\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main"></a> [main](#output\_main) | EKS values |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Tests

```bash
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
make init
make test_awspec
```

## Authors

The module is maintained by [Ivan Echegaray](https://github.com/punkerside)
