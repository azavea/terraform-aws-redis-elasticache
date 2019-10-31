locals {
  subnet_tag_name = "Type"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:${var.vpc_tag_name}"
    values = ["${var.vpc_name}${var.vpc_tag_value}"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.selected.id}"

  filter {
    name ="tag:${var.vpc_subnet_tag_name}"
    values = ["${var.vpc_subnet_tag_value}"]
  }

}

data "aws_security_group" "default" {
  // This is to use our existing security group for access from the hopper
  filter {
    name   = "${var.sg_filter_name}"
    values = ["${var.sg_filter_value}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.selected.id}"]
  }
}
