variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "efs"
}

variable "security_groups" {
  type = "list"
}

variable "vpc_id" {}

variable "aws_region" {}

variable "subnets" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

variable "zone_id" {}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}
