output "id" {
  value       = "${aws_efs_file_system.default.id}"
  description = "EFS id"
}

output "host" {
  value       = "${module.dns.hostname}"
  description = "Assigned DNS-record for the EFS"
}

output "dns_name" {
  value       = "${aws_efs_file_system.default.id}.efs.${var.aws_region}.amazonaws.com"
  description = "DNS name"
}

output "mount_target_ids" {
  value       = ["${aws_efs_mount_target.default.*.id}"]
  description = "List of IDs of the EFS mount targets (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = ["${aws_efs_mount_target.default.*.ip_address}"]
  description = "List of IPs of the EFS mount targets (one per Availability Zone)"
}
