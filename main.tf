locals {
  enabled = module.this.enabled

  dns_name               = "${join("", aws_efs_file_system.default.*.id)}.efs.${var.region}.amazonaws.com"
  security_group_enabled = local.enabled && var.create_security_group

  # returning null in the lookup function gives type errors and is not omitting the parameter
  # this work around ensures null is returned.
  secondary_gids = {
    for k, v in var.access_points :
    k => lookup(lookup(var.access_points[k], "posix_user", {}), "secondary_gids", null)
  }
}

resource "aws_efs_file_system" "default" {
  #bridgecrew:skip=BC_AWS_GENERAL_48: BC complains about not having an AWS Backup plan. We ignore this because this can be done outside of this module.
  count                           = local.enabled ? 1 : 0
  tags                            = module.this.tags
  availability_zone_name          = var.availability_zone_name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != "" || var.transition_to_primary_storage_class != "" ? [1] : [0]
    content {
      transition_to_ia                    = var.transition_to_ia != "" ? var.transition_to_ia : null
      transition_to_primary_storage_class = var.transition_to_primary_storage_class != "" ? var.transition_to_primary_storage_class : null
    }
  }
}

resource "aws_efs_mount_target" "default" {
  count          = local.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
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

  dynamic "posix_user" {
    for_each = local.secondary_gids[each.key] != null ? ["true"] : []

    content {
      gid            = var.access_points[each.key]["posix_user"]["gid"]
      uid            = var.access_points[each.key]["posix_user"]["uid"]
      secondary_gids = local.secondary_gids[each.key] != null ? split(",", local.secondary_gids[each.key]) : null
    }
  }

  root_directory {
    path = "/${each.key}"

    dynamic "creation_info" {
      for_each = try(lookup(var.access_points[each.key]["creation_info"]["gid"], ""), "") != "" ? ["true"] : []

      content {
        owner_gid   = var.access_points[each.key]["creation_info"]["gid"]
        owner_uid   = var.access_points[each.key]["creation_info"]["uid"]
        permissions = var.access_points[each.key]["creation_info"]["permissions"]
      }
    }
  }

  tags = module.this.tags
}

module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "0.4.2"

  enabled                       = local.security_group_enabled
  security_group_name           = var.security_group_name
  create_before_destroy         = var.security_group_create_before_destroy
  security_group_create_timeout = var.security_group_create_timeout
  security_group_delete_timeout = var.security_group_delete_timeout

  security_group_description = var.security_group_description
  allow_all_egress           = true
  rules                      = var.additional_security_group_rules
  rule_matrix = [
    {
      source_security_group_ids = local.allowed_security_group_ids
      cidr_blocks               = var.allowed_cidr_blocks
      rules = [
        {
          key         = null
          type        = "ingress"
          from_port   = 2049
          to_port     = 2049
          protocol    = "tcp"
          description = "Allow ingress EFS traffic"
        }
      ]
    }
  ]
  vpc_id = var.vpc_id

  context = module.this.context
}

module "dns" {
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.2"

  enabled  = local.enabled && length(var.zone_id) > 0
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
