## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | string | `-` | no |
| dns_name | Name of the CNAME record to create | string | `` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| encrypted | If true, the file system will be encrypted | bool | `false` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | string | `` | no |
| kms_key_id | If set, use a specific KMS key | string | `null` | no |
| mount_target_ip_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | string | `` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | string | `` | no |
| performance_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | string | `generalPurpose` | no |
| provisioned_throughput_in_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned | string | `0` | no |
| region | AWS Region | string | - | yes |
| security_groups | Security group IDs to allow access to the EFS | list(string) | - | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | string | `` | no |
| subnets | Subnet IDs | list(string) | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | map(string) | `<map>` | no |
| throughput_mode | Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps` | string | `bursting` | no |
| transition_to_ia | Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS and AFTER_90_DAYS | string | `` | no |
| vpc_id | VPC ID | string | - | yes |
| zone_id | Route53 DNS zone ID | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns_name | EFS DNS name |
| host | Route53 DNS hostname for the EFS |
| id | EFS ID |
| mount_target_dns_names | List of EFS mount target DNS names |
| mount_target_ids | List of EFS mount target IDs (one per Availability Zone) |
| mount_target_ips | List of EFS mount target IPs (one per Availability Zone) |
| network_interface_ids | List of mount target network interface IDs |
| security_group_arn | EFS Security Group ARN |
| security_group_id | EFS Security Group ID |
| security_group_name | EFS Security Group name |

