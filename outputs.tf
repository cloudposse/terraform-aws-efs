output "id" {
  value = "${aws_efs_file_system.default.id}"
}

output "host" {
  value = "${module.dns.hostname}"
}
