## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.0 |
| local | ~> 1.2 |
| null | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidr\_blocks | The whitelisted CIDRs which to allow `ingress` traffic to the DB instance | `list(string)` | `[]` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| dns\_name | Name of the CNAME record to create | `string` | `""` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| encrypted | If true, the file system will be encrypted | `bool` | `false` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| kms\_key\_id | If set, use a specific KMS key | `string` | `null` | no |
| mount\_target\_ip\_address | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | `string` | `""` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `""` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| performance\_mode | The file system performance mode. Can be either `generalPurpose` or `maxIO` | `string` | `"generalPurpose"` | no |
| provisioned\_throughput\_in\_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned | `number` | `0` | no |
| region | AWS Region | `string` | n/a | yes |
| security\_groups | Security group IDs to allow access to the EFS | `list(string)` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| subnets | Subnet IDs | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| throughput\_mode | Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps` | `string` | `"bursting"` | no |
| transition\_to\_ia | Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER\_7\_DAYS, AFTER\_14\_DAYS, AFTER\_30\_DAYS, AFTER\_60\_DAYS and AFTER\_90\_DAYS | `string` | `""` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |
| zone\_id | Route53 DNS zone ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns\_name | EFS DNS name |
| host | Route53 DNS hostname for the EFS |
| id | EFS ID |
| mount\_target\_dns\_names | List of EFS mount target DNS names |
| mount\_target\_ids | List of EFS mount target IDs (one per Availability Zone) |
| mount\_target\_ips | List of EFS mount target IPs (one per Availability Zone) |
| network\_interface\_ids | List of mount target network interface IDs |
| security\_group\_arn | EFS Security Group ARN |
| security\_group\_id | EFS Security Group ID |
| security\_group\_name | EFS Security Group name |

