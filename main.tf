resource "aws_iam_role" "this" {
  name = "${var.project}-${var.env}"

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

  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.this.name
}

resource "aws_eks_cluster" "this" {
  name     = "${var.project}-${var.env}"
  role_arn = aws_iam_role.this.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = concat(sort(var.subnet_private_ids), sort(var.subnet_public_ids), )
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name         = aws_eks_cluster.this.name
  node_group_name      = "${var.project}-${var.env}"
  node_role_arn        = aws_iam_role.this.arn
  subnet_ids           = var.subnet_private_ids
  ami_type             = var.ami_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
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

resource "aws_ec2_tag" "subnet_private_k8s" {
  count       = length(var.subnet_private_ids)
  resource_id = element(var.subnet_private_ids, count.index)
  key         = "kubernetes.io/cluster/${var.project}-${var.env}"
  value       = "shared"
}

resource "aws_ec2_tag" "subnet_public_elb" {
  count       = length(var.subnet_public_ids)
  resource_id = element(var.subnet_public_ids, count.index)
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "subnet_public_k8s" {
  count       = length(var.subnet_public_ids)
  resource_id = element(var.subnet_public_ids, count.index)
  key         = "kubernetes.io/cluster/${var.project}-${var.env}"
  value       = "shared"
}