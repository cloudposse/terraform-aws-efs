locals {
  dns_name               = "${join("", aws_efs_file_system.default.*.id)}.efs.${var.region}.amazonaws.com"
  security_group_enabled = module.this.enabled && var.security_group_enabled
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
  count          = module.this.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id = join("", aws_efs_file_system.default.*.id)
  ip_address     = var.mount_target_ip_address
  subnet_id      = var.subnets[count.index]
  security_groups = compact(
    sort(concat(
      [module.security_group.id],
      var.security_groups
    ))
  )
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

module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "0.3.1"

  use_name_prefix = var.security_group_use_name_prefix
  rules           = var.security_group_rules
  vpc_id          = var.vpc_id
  description     = var.security_group_description

  enabled = local.security_group_enabled
  context = module.this.context
}

module "dns" {
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.0"

  enabled  = module.this.enabled && length(var.zone_id) > 0 ? true : false
  dns_name = var.dns_name == "" ? module.this.id : var.dns_name
  ttl      = 60
  zone_id  = var.zone_id
  records  = [local.dns_name]

  context = module.this.context
}

resource "aws_efs_backup_policy" "policy" {
  count = module.this.enabled ? 1 : 0

  file_system_id = join("", aws_efs_file_system.default.*.id)

  backup_policy {
    status = var.efs_backup_policy_enabled ? "ENABLED" : "DISABLED"
  }
}
