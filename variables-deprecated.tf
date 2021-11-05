variable "security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
  DEPRECATED: Use `allowed_security_group_ids` instead.
  A list of Security Group IDs to associate with EFS.
  EOT
}

variable "security_group_suffix" {
  type        = string
  default     = ""
  description = <<-EOT
  DEPRECATED: Use the module's attributes instead.
  A suffix of `efs` was used in versions 0.30.1 and earlier.
  EOT
}