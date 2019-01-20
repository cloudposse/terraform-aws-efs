output "id" {
  value       = "${local.enabled ? join("", aws_efs_file_system.default.*.id) : ""}"
  description = "EFS id"
}

output "host" {
  value       = "${local.enabled ? module.dns.hostname : ""}"
  description = "Assigned DNS-record for the EFS"
}

output "dns_name" {
  value       = "${local.enabled ? local.dns_name : "" }"
  description = "DNS name"
}

output "mount_target_ids" {
  value       = ["${local.enabled ? aws_efs_mount_target.default.*.id : "" }"]
  description = "List of IDs of the EFS mount targets (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = ["${local.enabled ? aws_efs_mount_target.default.*.ip_address : "" }"]
  description = "List of IPs of the EFS mount targets (one per Availability Zone)"
}
