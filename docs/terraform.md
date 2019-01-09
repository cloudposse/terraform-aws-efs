## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| availability_zones | Availability Zone IDs | list | - | yes |
| aws_region | AWS region ID | string | - | yes |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| encrypted | If true, the disk will be encrypted. | string | `false` | no |
| mount_target_ip_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target. | string | `` | no |
| name | Name (_e.g._ `app` or `wordpress`) | string | `app` | no |
| namespace | Namespace (_e.g._ `cp` or `cloudposse`) | string | `global` | no |
| performance_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | string | `generalPurpose` | no |
| provisioned_throughput_in_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned. | string | `0` | no |
| security_groups | AWS security group IDs to allow to connect to the EFS | list | - | yes |
| stage | Stage (_e.g._ `prod`, `dev`, `staging`) | string | `default` | no |
| subnets | AWS subnet IDs | list | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | map | `<map>` | no |
| throughput_mode | Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps. | string | `bursting` | no |
| vpc_id | AWS VPC ID | string | - | yes |
| zone_id | Route53 dns zone ID | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns_name | DNS name |
| host | Assigned DNS-record for the EFS |
| id | EFS ID |
| mount_target_dns_names | List of DNS names for the given subnet/AZ per documented convention. |
| mount_target_ids | List of IDs of the EFS mount targets (one per Availability Zone) |
| mount_target_ips | List of IPs of the EFS mount targets (one per Availability Zone) |
| network_interface_ids | The IDs of the network interface that Amazon EFS created when it created the mount target. |

