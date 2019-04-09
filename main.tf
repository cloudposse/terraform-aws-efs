# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.7.0"
  enabled    = "${var.enabled}"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

locals {
  enabled  = "${var.enabled == "true"}"
  dns_name = "${join("", aws_efs_file_system.default.*.id)}.efs.${var.aws_region}.amazonaws.com"
}

resource "aws_efs_file_system" "default" {
  count                           = "${local.enabled ? 1 : 0}"
  tags                            = "${module.label.tags}"
  encrypted                       = "${var.encrypted}"
  performance_mode                = "${var.performance_mode}"
  provisioned_throughput_in_mibps = "${var.provisioned_throughput_in_mibps}"
  throughput_mode                 = "${var.throughput_mode}"
}

resource "aws_efs_mount_target" "default" {
  count           = "${local.enabled && length(var.availability_zones) > 0 ? length(var.availability_zones) : 0}"
  file_system_id  = "${join("", aws_efs_file_system.default.*.id)}"
  ip_address      = "${var.mount_target_ip_address}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${join("", aws_security_group.default.*.id)}"]
}

resource "aws_security_group" "default" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${module.label.id}"
  description = "EFS"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "2049"                     # NFS
    to_port         = "2049"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${module.label.tags}"
}

module "dns" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.2.5"
  enabled   = "${local.enabled && length(var.zone_id) > 0 ? "true" : "false"}"
  name      = "${module.label.id}"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  ttl       = 60
  zone_id   = "${var.zone_id}"
  records   = ["${local.dns_name}"]
}
