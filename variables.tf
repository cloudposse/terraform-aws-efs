variable "namespace" {
  default     = "global"
  description = "Namespace (_e.g._ `cp` or `cloudposse`)"
}

variable "stage" {
  default     = "default"
  description = "Stage (_e.g._ `prod`, `dev`, `staging`)"
}

variable "name" {
  default     = "app"
  description = "Name (_e.g._ `app` or `wordpress`)"
}

variable "security_groups" {
  type        = "list"
  description = "AWS security group IDs to allow to connect to the EFS"
}

variable "vpc_id" {
  description = "AWS VPC ID"
}

variable "aws_region" {
  description = "AWS region ID"
}

variable "subnets" {
  type        = "list"
  description = "AWS subnet IDs"
}

variable "availability_zones" {
  type        = "list"
  description = "Availability Zone IDs"
}

variable "zone_id" {
  default     = ""
  description = "Route53 dns zone ID"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
}

variable "encrypted" {
  type        = "string"
  default     = "false"
  description = "If true, the disk will be encrypted."
}

variable "performance_mode" {
  type        = "string"
  default     = "generalPurpose"
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
}

variable "provisioned_throughput_in_mibps" {
  default     = ""
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned."
}

variable "throughput_mode" {
  default     = "bursting"
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps."
}

variable "mount_target_ip_address" {
  default     = ""
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target."
}
