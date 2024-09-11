variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "Availability zones must be greater than zero."
  }
}
