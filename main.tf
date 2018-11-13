# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

resource "aws_efs_file_system" "default" {
  tags = "${module.label.tags}"
}

resource "aws_efs_mount_target" "default" {
  count           = "${length(var.availability_zones)}"
  file_system_id  = "${aws_efs_file_system.default.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
}

resource "aws_security_group" "default" {
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
  enabled   = "${length(var.zone_id) > 0 ? "true" : "false"}"
  name      = "${module.label.id}"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  ttl       = 60
  zone_id   = "${var.zone_id}"
  records   = ["${aws_efs_file_system.default.id}.efs.${var.aws_region}.amazonaws.com"]
}
