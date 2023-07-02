resource "aws_iam_role" "main" {
  name = var.name == null ? random_string.main.result : var.name
  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["eks.amazonaws.com", "ec2.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "main" {
  name = var.name == null ? random_string.main.result : var.name
  role = aws_iam_role.main.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*",
        "wafv2:*",
        "waf-regional:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.main.name
}

resource "aws_kms_key" "main" {
  enable_key_rotation = true
  tags                = var.tags
}

resource "aws_eks_cluster" "main" {
  name                      = var.name == null ? random_string.main.result : var.name
  role_arn                  = aws_iam_role.main.arn
  version                   = var.eks_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  tags                      = var.tags

  vpc_config {
    subnet_ids              = concat(sort(var.subnet_private_ids), sort(var.subnet_public_ids), )
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.main.arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}

resource "aws_eks_node_group" "main" {
  cluster_name         = aws_eks_cluster.main.name
  node_group_name      = "default"
  node_role_arn        = aws_iam_role.main.arn
  subnet_ids           = var.subnet_private_ids
  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types
  tags                 = var.tags

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_ec2_tag" "subnet_private_elb" {
  count       = length(var.subnet_private_ids)
  resource_id = element(var.subnet_private_ids, count.index)
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "subnet_public_elb" {
  count       = length(var.subnet_public_ids)
  resource_id = element(var.subnet_public_ids, count.index)
  key         = "kubernetes.io/role/elb"
  value       = "1"
}