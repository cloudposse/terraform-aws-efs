output "access_point_arns" {
  value       = local.enabled ? { for arn in sort(keys(var.access_points)) : arn => aws_efs_access_point.default[arn].arn } : null
  description = "EFS AP ARNs"
}

output "access_point_ids" {
  value       = local.enabled ? { for id in sort(keys(var.access_points)) : id => aws_efs_access_point.default[id].id } : null
  description = "EFS AP ids"
}

output "arn" {
  value       = local.enabled ? join("", aws_efs_file_system.default.*.arn) : null
  description = "EFS ARN"
}

output "id" {
  value       = local.enabled ? join("", aws_efs_file_system.default.*.id) : null
  description = "EFS ID"
}

output "host" {
  value       = module.dns.hostname
  description = "Route53 DNS hostname for the EFS"
}

output "dns_name" {
  value       = local.enabled ? local.dns_name : null
  description = "EFS DNS name"
}

output "mount_target_dns_names" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.mount_target_dns_name, [""]) : null
  description = "List of EFS mount target DNS names"
}

output "mount_target_ids" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.id, [""]) : null
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.ip_address, [""]) : null
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.network_interface_id, [""]) : null
  description = "List of mount target network interface IDs"
}

output "security_group_id" {
  value       = module.security_group.id
  description = "EFS Security Group ID"
}

output "security_group_arn" {
  value       = module.security_group.arn
  description = "EFS Security Group ARN"
}

output "security_group_name" {
  value       = module.security_group.name
  description = "EFS Security Group name"
}
