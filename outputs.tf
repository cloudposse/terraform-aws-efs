output "id" {
  description = "ID of EFS"
  value       = "${aws_efs_file_system.default.id}"
}

output "host" {
  description = "Assigned DNS-record for the EFS"
  value       = "${module.dns.hostname}"
}

output "dns_name" {
  description = ""
  value       = "${aws_efs_file_system.default.id}.efs.${local.region}.amazonaws.com"
}

output "mount_target_ids" {
  description = "List of IDs of the EFS mount targets"
  value       = ["${aws_efs_mount_target.default.*.id}"]
}

output "mount_target_ips" {
  description = "List of IPs of the EFS mount targets"
  value       = ["${aws_efs_mount_target.default.*.ip_address}"]
}
