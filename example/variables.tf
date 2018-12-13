variable "region" {
  default = "us-east-1"
}

variable "attributes" {
  default = []
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

variable "availability_zones" {}
variable "provisioned_throughput_in_mibps" {}
variable "security_groups" {}
variable "subnets" {}
variable "throughput_mode" {}
variable "vpc_id" {}
variable "zone_id" {}
