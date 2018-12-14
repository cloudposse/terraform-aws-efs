variable "region" {
  default = "us-east-1"
}

variable "attributes" {
  default = []
  type = "list"
}

variable "namespace" {
  default = "eg"
}

variable "name" {
  default = "efs"
}

variable "stage" {
  default = "testing"
}

variable "availability_zones" {
  type = "list"
}
variable "provisioned_throughput_in_mibps" {}
variable "security_groups" {
  type = "list"
}
variable "subnets" {
  type = "list"
}
variable "throughput_mode" {}
variable "vpc_id" {}
variable "zone_id" {}
