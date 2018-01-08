# terraform-aws-efs [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-efs.svg)](https://travis-ci.org/cloudposse/terraform-aws-efs)

Terraform module to provision an AWS [`EFS`](https://aws.amazon.com/efs/) Network File System.


## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "efs" {
  source     = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=master"
  namespace  = "global"
  name       = "app"
  stage      = "prod"
  attributes = "efs"

  aws_region         = "${var.aws_region}"
  vpc_id             = "${var.vpc_id}"
  subnets            = "${var.private_subnets}"
  availability_zones = ["${var.availability_zones}"]
  security_groups    = ["${var.security_group_id}"]

  zone_id = "${var.aws_route53_dns_zone_id}"
}
```

## Input

|  Name              |    Default     |                          Description                             |
|:-------------------|:--------------:|:-----------------------------------------------------------------|
| namespace          | `global`       | Namespace (_e.g._ `cp` or `cloudposse`)                          |
| stage              | `default`      | Stage (_e.g._ `prod`, `dev`, `staging`)                          |
| name               | `app`          | Name (_e.g._ `app` or `wordpress`)                               |
| security_groups    | `[]`           | AWS security group IDs to allow to connect to the EFS            |
| aws_region         | __REQUIRED__   | AWS region ID                                                    |
| vpc_id             | __REQUIRED__   | AWS VPC ID                                                       |
| subnets            | __REQUIRED__   | AWS subnet IDs                                                   |
| availability_zones | __REQUIRED__   | Availability Zone IDs                                            |
| zone_id            | __REQUIRED__   | Route53 dns zone ID                                              |
| attributes         | `[]`           | Additional attributes (e.g. `policy` or `role`)                  |
| tags               | `{}`           | Additional tags  (e.g. `map("BusinessUnit","XYZ")`               |
| delimiter          | `-`            | Delimiter to be used between `name`, `namespace`, `stage`, etc.  |


## Output

| Name             |        Description                                               |
|:-----------------|:-----------------------------------------------------------------|
| id               | EFS id                                                           |
| host             | Assigned DNS-record for the EFS                                  |
| mount_target_ids | List of IDs of the EFS mount targets (one per Availability Zone) |
| mount_target_ips | List of IPs of the EFS mount targets (one per Availability Zone) |
