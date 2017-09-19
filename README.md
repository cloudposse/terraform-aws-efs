# tf_efs

Terraform module to provision an AWS EFS Network File System.

## Usage

Include this repository as a module in your existing terraform code:

```
module "efs" {
  source     = "git::https://github.com/cloudposse/tf_efs.git?ref=tags/0.2.0"
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
| security_groups    | `[]`           | AWS security group ids to allow to connect to the EFS            |
| aws_region         | __REQUIRED__   | AWS region id                                                    |
| vpc_id             | __REQUIRED__   | AWS VPC id                                                       |
| subnets            | `[]`           | AWS subnet ids                                                   |
| availability_zones | `[]`           | Availability zone ids                                            |
| zone_id            | __REQUIRED__   | Route53 dns zone id                                              |
| attributes         | `[]`           | Additional attributes (e.g. `policy` or `role`)                  |
| tags               | `{}`           | Additional tags  (e.g. `map("BusinessUnit","XYZ")`               |
| delimiter          | `-`            | Delimiter to be used between `name`, `namespace`, `stage`, etc.  |


## Output

| Name |        Description              |
|:-----|:--------------------------------|
| id   | EFS id                          |
| host | Assigned DNS-record for the EFS |
