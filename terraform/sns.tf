resource "aws_sns_topic" "this" {
  name = "${var.owner}-${var.env}-${var.project}"
  tags = {
      owner   = "${var.owner}"
      project = "${var.project}"
      env     = "${var.env}"
  }
}
