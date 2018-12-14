provider "aws" {
  region = "${var.region}"
}

module "efs" {
  source     = "../"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"

  aws_region         = "${var.region}"
  availability_zones = ["${var.availability_zones}"]
  security_groups    = ["${var.security_groups}"]
  subnets            = "${var.subnets}"
  zone_id            = "${var.zone_id}"
  vpc_id             = "${var.vpc_id}"

  throughput_mode                 = "${var.throughput_mode}"
  provisioned_throughput_in_mibps = "${var.provisioned_throughput_in_mibps}"
}
