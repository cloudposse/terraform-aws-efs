variable "security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
  DEPRECATED: Use `allowed_security_group_ids` instead.
  A list of Security Group IDs to associate with EFS.
  EOT
}
