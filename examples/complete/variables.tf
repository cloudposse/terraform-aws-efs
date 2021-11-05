variable "region" {
  type = string
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "Availability zones must be greater than zero."
  }
}

variable "security_group_suffix" {
  type        = string
  default     = ""
  description = <<-EOT
  DEPRECATED: Use the module's attributes instead.
  A suffix of `efs` was used in versions 0.30.1 and earlier.
  EOT
}
