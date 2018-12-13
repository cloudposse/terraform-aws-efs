output "arn" {
  value       = "${aws_efs_file_system.default.arn}"
  description = "EFS arn"
}

output "id" {
  value       = "${aws_efs_file_system.default.id}"
  description = "EFS id"
}

output "host" {
  value       = "${module.dns.hostname}"
  description = "Assigned DNS-record for the EFS"
}

output "dns_name" {
  value       = "${aws_efs_file_system.default.dns_name}"
  description = "DNS name"
}

output "mount_target_dns_names" {
  value       = "${aws_efs_mount_target.default.*.dns_name}"
  description = "The DNS names for the given subnet/AZ per documented convention."
}

output "mount_target_ids" {
  value       = ["${aws_efs_mount_target.default.*.id}"]
  description = "List of IDs of the EFS mount targets (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = ["${aws_efs_mount_target.default.*.ip_address}"]
  description = "List of IPs of the EFS mount targets (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = ["${aws_efs_mount_target.default.*.network_interface_id}"]
  description = "The ID of the network interface that Amazon EFS created when it created the mount target."
}
