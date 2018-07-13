
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| availability_zones | Availability Zone IDs | list | - | yes |
| aws_region | AWS region ID | string | - | yes |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| name | Name (_e.g._ `app` or `wordpress`) | string | `app` | no |
| namespace | Namespace (_e.g._ `cp` or `cloudposse`) | string | `global` | no |
| security_groups | AWS security group IDs to allow to connect to the EFS | list | - | yes |
| stage | Stage (_e.g._ `prod`, `dev`, `staging`) | string | `default` | no |
| subnets | AWS subnet IDs | list | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | map | `<map>` | no |
| vpc_id | AWS VPC ID | string | - | yes |
| zone_id | Route53 dns zone ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns_name | DNS name |
| host | Assigned DNS-record for the EFS |
| id | EFS id |
| mount_target_ids | List of IDs of the EFS mount targets (one per Availability Zone) |
| mount_target_ips | List of IPs of the EFS mount targets (one per Availability Zone) |

