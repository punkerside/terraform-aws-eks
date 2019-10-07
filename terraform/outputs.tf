output "role" {
  value = "${aws_iam_role.node.arn}"
}

output "aws_autoscaling_group" {
  value = "${aws_autoscaling_group.this.name}"
}

output "aws_sns_topic" {
  value = "${aws_sns_topic.this.arn}"
}