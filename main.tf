# Define composite variables for resources
resource "null_resource" "default" {
  triggers = {
    id = "${lower(format("%v-%v-%v", var.namespace, var.stage, var.name))}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_file_system" "default" {
  tags {
    Name      = "${null_resource.default.triggers.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

resource "aws_efs_mount_target" "default" {
  count           = "${length(var.availability_zones)}"
  file_system_id  = "${aws_efs_file_system.default.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
}

resource "aws_security_group" "default" {
  name        = "${null_resource.default.triggers.id}"
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

  tags {
    Name      = "${null_resource.default.triggers.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

module "dns" {
  source    = "../hostname"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
  ttl       = 60
  zone_id   = "${var.zone_id}"
  records   = ["${aws_efs_file_system.default.id}.efs.${var.aws_region}.amazonaws.com"]
}
