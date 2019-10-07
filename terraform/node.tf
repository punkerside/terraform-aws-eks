resource "aws_iam_role" "notification" {
  name = "${var.owner}-${var.env}-${var.project}-notification"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      owner   = "${var.owner}"
      project = "${var.project}"
      env     = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "notification_00" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
  role       = "${aws_iam_role.notification.name}"
}

resource "aws_iam_role" "node" {
  name = "${var.owner}-${var.env}-${var.project}-node"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      owner   = "${var.owner}"
      project = "${var.project}"
      env     = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "node_00" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node_01" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node_02" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node_03" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node_04" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node_05" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node_06" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.owner}-${var.env}-${var.project}-node"
  role = "${aws_iam_role.node.name}"
}

resource "aws_security_group" "node" {
  name        = "${var.owner}-${var.env}-${var.project}-node"
  description = "Allow inbound traffic for node"
  vpc_id      = "${data.aws_vpc.this.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "node_00" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node.id}"
  source_security_group_id = "${aws_security_group.node.id}"
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_01" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node.id}"
  source_security_group_id = "${aws_security_group.master.id}"
  type                     = "ingress"
}

resource "aws_launch_template" "this" {
  name_prefix            = "${var.owner}-${var.env}-${var.project}-"
  image_id               = "${data.aws_ami.eks-node.id}"
  key_name               = "${var.owner}-${var.env}"
  vpc_security_group_ids = ["${aws_security_group.node.id}"]
  user_data              = "${base64encode(local.userdata)}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = 80
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = "${aws_iam_instance_profile.node.name}"
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.owner}-${var.env}-${var.project}-"
  max_size                  = "${var.node_max}"
  min_size                  = "${var.node_min}"
  desired_capacity          = "${var.node_des}"
  vpc_zone_identifier       = "${data.aws_subnet_ids.pri.ids}"
  metrics_granularity       = "1Minute"
  enabled_metrics           = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.this.id}"
      }

      override {
        instance_type = "r5.large"
      }

      override {
        instance_type = "m5.large"
      }
    }
    instances_distribution {
      on_demand_percentage_above_base_capacity = 25
      spot_allocation_strategy                 = "lowest-price"
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.owner}-${var.env}-${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.owner}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.this.id}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.owner}-${var.env}"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_notification" "this" {
  group_names = [
    "${aws_autoscaling_group.this.name}"
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = "${aws_sns_topic.this.arn}"
}