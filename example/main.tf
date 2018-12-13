provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

module "efs" {
  source = "../"

  security_groups    = "${var.security_groups}"
  vpc_id             = "${var.vpc_id}"
  aws_region         = "${var.aws_region}"
  subnets            = "${var.subnets}"
  availability_zones = "${data.aws_availability_zones.available.names}"
}
