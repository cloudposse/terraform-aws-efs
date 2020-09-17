locals {
  dns_name = "${join("", aws_efs_file_system.default.*.id)}.efs.${var.region}.amazonaws.com"
}

resource "aws_efs_file_system" "default" {
  count                           = module.this.enabled ? 1 : 0
  tags                            = module.this.tags
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia == "" ? [] : [1]
    content {
      transition_to_ia = var.transition_to_ia
    }
  }
}

resource "aws_efs_mount_target" "default" {
  count           = module.this.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = [join("", aws_security_group.efs.*.id)]
}

resource "aws_efs_access_point" "default" {
  for_each = var.access_points

  file_system_id = join("", aws_efs_file_system.default.*.id)

  posix_user {
    gid = var.access_points[each.key]["posix_user"]["gid"]
    uid = var.access_points[each.key]["posix_user"]["uid"]
    # Just returning null in the lookup function gives type errors and is not omitting the parameter, this work around ensures null is returned.
    secondary_gids = lookup(lookup(var.access_points[each.key], "posix_user", {}), "secondary_gids", null) == null ? null : null
  }

  root_directory {
    path = "/${each.key}"
    creation_info {
      owner_gid   = var.access_points[each.key]["creation_info"]["gid"]
      owner_uid   = var.access_points[each.key]["creation_info"]["uid"]
      permissions = var.access_points[each.key]["creation_info"]["permissions"]
    }
  }

  tags = module.this.tags
}

resource "aws_security_group" "efs" {
  count       = module.this.enabled ? 1 : 0
  name        = format("%s-efs", module.this.id)
  description = "EFS Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = module.this.tags
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = module.this.enabled ? length(var.security_groups) : 0
  description              = "Allow inbound traffic from existing security groups"
  type                     = "ingress"
  from_port                = "2049" # NFS
  to_port                  = "2049"
  protocol                 = "tcp"
  source_security_group_id = var.security_groups[count.index]
  security_group_id        = join("", aws_security_group.efs.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = module.this.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = "2049" # NFS
  to_port           = "2049"
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.efs.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = module.this.enabled ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.efs.*.id)
}

module "dns" {
  source = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.7.0"

  enabled  = module.this.enabled && length(var.zone_id) > 0 ? true : false
  dns_name = var.dns_name == "" ? module.this.id : var.dns_name
  ttl      = 60
  zone_id  = var.zone_id
  records  = [local.dns_name]

  context = module.this.context
}
