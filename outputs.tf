output "access_point_arns" {
  value       = { for arn in sort(keys(var.access_points)) : arn => aws_efs_access_point.default[arn].arn }
  description = "EFS AP ARNs"
}

output "access_point_ids" {
  value       = { for id in sort(keys(var.access_points)) : id => aws_efs_access_point.default[id].id }
  description = "EFS AP ids"
}

output "arn" {
  value       = join("", aws_efs_file_system.default.*.arn)
  description = "EFS ARN"
}

output "id" {
  value       = join("", aws_efs_file_system.default.*.id)
  description = "EFS ID"
}

output "host" {
  value       = module.dns.hostname
  description = "Route53 DNS hostname for the EFS"
}

output "dns_name" {
  value       = local.dns_name
  description = "EFS DNS name"
}

output "mount_target_dns_names" {
  value       = coalescelist(aws_efs_mount_target.default.*.mount_target_dns_name, [""])
  description = "List of EFS mount target DNS names"
}

output "mount_target_ids" {
  value       = coalescelist(aws_efs_mount_target.default.*.id, [""])
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = coalescelist(aws_efs_mount_target.default.*.ip_address, [""])
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = coalescelist(aws_efs_mount_target.default.*.network_interface_id, [""])
  description = "List of mount target network interface IDs"
}

output "security_group_id" {
  value       = join("", aws_security_group.efs.*.id)
  description = "EFS Security Group ID"
}

output "security_group_arn" {
  value       = join("", aws_security_group.efs.*.arn)
  description = "EFS Security Group ARN"
}

output "security_group_name" {
  value       = join("", aws_security_group.efs.*.name)
  description = "EFS Security Group name"
}
