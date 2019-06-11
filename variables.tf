variable "enabled" {
  type        = string
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "namespace" {
  type        = string
  description = "Namespace (_e.g._ `eg` or `cp`)"
  default     = "eg"
}

variable "stage" {
  type        = string
  description = "Stage (_e.g._ `prod`, `dev`, `staging`)"
  default     = "default"
}

variable "name" {
  type        = string
  description = "Name (_e.g._ `app`)"
  default     = "app"
}

variable "security_groups" {
  type        = list(string)
  description = "Security group IDs to allow access to the EFS"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zone IDs"
}

variable "zone_id" {
  type        = string
  description = "Route53 DNS zone ID"
  default     = ""
}

variable "delimiter" {
  type        = string
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
  default     = "-"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (e.g. `1`)"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}

variable "encrypted" {
  type        = string
  description = "If true, the disk will be encrypted"
  default     = "false"
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned"
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps"
  default     = "bursting"
}

variable "mount_target_ip_address" {
  type        = string
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
  default     = ""
}

variable "dns_name" {
  type        = string
  description = "Name of the CNAME record to create."
  default     = ""
}

