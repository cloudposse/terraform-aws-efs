# terraform-aws-efs [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-efs.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-efs)

Terraform module to provision an AWS [`EFS`](https://aws.amazon.com/efs/) Network File System.


## Usage

Include this repository as a module in your existing terraform code:

```terraform
module "efs" {
  source          = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=master"
  namespace       = "global"
  name            = "app"
  stage           = "prod"
  attributes      = "efs"
  vpc_id          = "${var.vpc_id}"
  subnets         = "${var.private_subnets}"
  security_groups = ["${var.security_group_id}"]
  zone_id         = "${var.aws_route53_dns_zone_id}"
}
```

## Input

| Name               |     Default      | Description                                                                                       | Required |
|:-------------------|:----------------:|:--------------------------------------------------------------------------------------------------|:--------:|
| `namespace`        |        ``        | Namespace (_e.g._ `cp` or `cloudposse`)                                                           |   Yes    |
| `stage`            |        ``        | Stage (_e.g._ `prod`, `dev`, `staging`)                                                           |   Yes    |
| `name`             |        ``        | Name (_e.g._ `app` or `wordpress`)                                                                |   Yes    |
| `attributes`       |       `[]`       | Additional attributes (e.g. `policy` or `role`)                                                   |    No    |
| `tags`             |       `{}`       | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                |    No    |
| `delimiter`        |       `-`        | Delimiter to be used between `name`, `namespace`, `stage`, etc.                                   |    No    |
| `security_groups`  |       `[]`       | AWS security group IDs to allow to connect to the EFS                                             |   Yes    |
| `vpc_id`           |        ``        | AWS VPC ID                                                                                        |   Yes    |
| `subnets`          |       `[]`       | AWS subnet IDs                                                                                    |   Yes    |
| `zone_id`          |        ``        | Route53 DNS zone ID                                                                               |    No    |
| `performance_mode` | `generalPurpose` | The file system performance mode. Can be either generalPurpose or maxIO                           |    No    |
| `encrypted`        |     `false`      | If true, the disk will be encrypted                                                               |    No    |
| `kms_key_id`       |        ``        | ARN for the KMS encryption key. When specifying `kms_key_id`, encrypted needs to be set to `true` |    No    |
| `enabled`          |      `true`      | Set to false to prevent the module from creating anything                                         |    No    |
| `ttl`              |       `60`       | TTL of the record                                                                                 |    No    |



## Output

| Name               | Description                          |
|:-------------------|:-------------------------------------|
| `id`               | ID of EFS                            |
| `host`             | Assigned DNS-record for the EFS      |
| `mount_target_ids` | List of IDs of the EFS mount targets |
| `mount_target_ips` | List of IPs of the EFS mount targets |
| `dns_name`         | DNS name of EFS                      |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
