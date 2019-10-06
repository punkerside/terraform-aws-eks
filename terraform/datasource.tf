# capturando ip publica
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# creando configuracion para la integracion de los nodos con el cluster
locals {
  myip = "${chomp(data.http.myip.body)}/32"
  userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority.0.data}' '${aws_eks_cluster.this.id}'
USERDATA
}

# capturando id de vpc
data "aws_vpc" "this" {
  tags = {
    Name = "${var.owner}-${var.env}"
  }
}

# capturando ids de subnets publicas
data "aws_subnet_ids" "pub" {
  vpc_id = "${data.aws_vpc.this.id}"

  tags = {
    Tier = "pub"
  }
}

# capturando ids de subnets privadas
data "aws_subnet_ids" "pri" {
  vpc_id = "${data.aws_vpc.this.id}"

  tags = {
    Tier = "pri"
  }
}

# capturando ami de nodo
data "aws_ami" "eks-node" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.node_ver}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}