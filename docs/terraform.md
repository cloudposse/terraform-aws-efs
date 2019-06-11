## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| availability_zones | Availability Zone IDs | list | - | yes |
| aws_region | AWS Region | string | - | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| dns_name | Name of the CNAME record to create. | string | `` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | true | no |
| encrypted | If true, the disk will be encrypted | string | `false` | no |
| mount_target_ip_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | string | `` | no |
| name | Name (_e.g._ `app`) | string | `app` | no |
| namespace | Namespace (_e.g._ `eg` or `cp`) | string | `eg` | no |
| performance_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | string | `generalPurpose` | no |
| provisioned_throughput_in_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned | string | `0` | no |
| security_groups | Security group IDs to allow access to the EFS | list | - | yes |
| stage | Stage (_e.g._ `prod`, `dev`, `staging`) | string | `default` | no |
| subnets | Subnet IDs | list | - | yes |
| tags | Additional tags (e.g. `{ BusinessUnit = "XYZ" }` | map | `<map>` | no |
| throughput_mode | Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps | string | `bursting` | no |
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

