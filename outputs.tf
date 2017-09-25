output "id" {
  value = "${aws_efs_file_system.default.id}"
}

output "host" {
  value = "${module.dns.hostname}"
}

output "dns_name" {
  value = "${aws_efs_file_system.default.id}.efs.${var.aws_region}.amazonaws.com"
}
