data "aws_region" "default" {
  current = "true"
}

locals {
  region  = "${length(var.region) > 0 ? var.region: data.aws_region.default.name}"
  zone_id = "${length(var.zone_id) > 0 ? "true" : "false"}"
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

resource "aws_efs_file_system" "default" {
  count            = "${var.enabled == "true" ? 1 : 0}"
  performance_mode = "${var.performance_mode}"
  encrypted        = "${var.encrypted}"
  kms_key_id       = "${var.kms_key_id}"
  tags             = "${module.label.tags}"
}

resource "aws_efs_mount_target" "default" {
  count           = "${var.enabled == "true" ? length(compact(var.subnets)) : 0}"
  file_system_id  = "${aws_efs_file_system.default.id}"
  subnet_id       = "${element(compact(var.subnets), count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
}

resource "aws_security_group" "default" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  name        = "${module.label.id}"
  description = "EFS"
  vpc_id      = "${var.vpc_id}"
  tags        = "${module.label.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  count                    = "${var.enabled == "true" ? length(compact(var.security_groups)) : 0}"
  type                     = "ingress"
  from_port                = "2049"
  to_port                  = "2049"
  protocol                 = "tcp"
  source_security_group_id = "${element(compact(var.security_groups), count.index)}"
  security_group_id        = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "egress" {
  count             = "${var.enabled == "true" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}

module "dns" {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.2.1"
  name    = "${module.label.id}"
  ttl     = "${var.ttl}"
  zone_id = "${var.zone_id}"
  records = ["${aws_efs_file_system.default.id}.efs.${local.region}.amazonaws.com"]
  enabled = "${local.zone_id}"
}
