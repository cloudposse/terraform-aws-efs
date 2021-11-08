# Intentionally not deprecated via security_group_inputs.tf since it cannot effectively be replaced via var.additional_security_group_rules.
# This is because the logic to create these rules exists within this module, and should not be passed in by the consumer
# of this module.
variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "The CIDR blocks from which to allow `ingress` traffic to the EFS"
}

variable "access_points" {
  type        = map(map(map(any)))
  default     = {}
  description = <<-EOT
    A map of the access points you would like in your EFS volume

    See [examples/complete] for an example on how to set this up. All keys are strings. The primary keys are the names of access points. The secondary keys are `posix_user` and `creation_info`. The secondary_gids key should be a comma separated value. More information can be found in the terraform resource [efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point).
    EOT
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "zone_id" {
  type        = list(string)
  default     = []
  description = <<-EOT
    Route53 DNS Zone ID as list of string (0 or 1 items). If empty, no custom DNS name will be published.
    If the list contains a single Zone ID, a custom DNS name will be pulished in that zone.
    Can also be a plain string, but that use is DEPRECATED because of Terraform issues.
    EOT
}

variable "encrypted" {
  type        = bool
  description = "If true, the file system will be encrypted"
  default     = true
}

variable "kms_key_id" {
  type        = list(string)
  description = "If set, use a specific KMS key"
  default     = []
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  type        = number
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  default     = "bursting"
}

variable "mount_target_ip_address" {
  type        = string
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
  default     = null
}

variable "dns_name" {
  type        = string
  description = "Name of the CNAME record to create"
  default     = ""
}

variable "transition_to_ia" {
  type        = list(string)
  description = "Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS and AFTER_90_DAYS"
  default     = []
  validation {
    condition = (
      length(var.transition_to_ia) == 1 ? contains(["AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS"], var.transition_to_ia[0]) : length(var.transition_to_ia) == 0
    )
    error_message = "Var `transition_to_ia` must either be empty list or one of \"AFTER_7_DAYS\", \"AFTER_14_DAYS\", \"AFTER_30_DAYS\", \"AFTER_60_DAYS\", \"AFTER_90_DAYS\"."
  }
}

variable "transition_to_primary_storage_class" {
  type        = list(string)
  description = "Describes the policy used to transition a file from infequent access storage to primary storage. Valid values: AFTER_1_ACCESS."
  default     = []
  validation {
    condition = (
      length(var.transition_to_primary_storage_class) == 1 ? contains(["AFTER_1_ACCESS"], var.transition_to_primary_storage_class[0]) : length(var.transition_to_primary_storage_class) == 0
    )
    error_message = "Var `transition_to_primary_storage_class` must either be empty list or \"AFTER_1_ACCESS\"."
  }
}

variable "efs_backup_policy_enabled" {
  type        = bool
  description = "If `true`, it will turn on automatic backups."
  default     = false
}

variable "availability_zone_name" {
  type        = list(string)
  description = "AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes. If set, a single subnet in the same availability zone should be provided to `subnets`"
  default     = []
}
