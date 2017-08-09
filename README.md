# tf_efs

Terraform module to provision an AWS EFS Network File System.

## Usage

Include this repository as a module in your existing terraform code:

```
module "efs" {
  source    = "git::https://github.com/cloudposse/tf_efs.git?ref=tags/0.1.0"
  namespace       = "general"
  name            = "nfs"
  stage           = "prod"

  aws_region         = "${var.aws_region}"
  vpc_id             = "${var.vpc_id}"
  subnets            = "${var.private_subnets}"
  availability_zones = ["${var.availability_zones}"]
  security_groups    = ["${var.security_group_id}"]

  zone_id = "${var.aws_route53_dns_zone_id}"
}
```

## Input

|  Name              |  Default     |  Decription            |
|:------------------:|:------------:|:----------------------:|
| namespace          | global       | Namespace              |
| stage              | default      | Stage                  |
| name               | redis        | Name                   |
| security_groups    | []           | AWS security group ids |
| aws_region         | __REQUIRED__ | AWS region id          |
| vpc_id             | __REQUIRED__ | AWS VPC id             |
| subnets            | []           | AWS subnet ids         |
| availability_zones | []           | Availability zone ids  |
| zone_id            | __REQUIRED__ | Route53 dns zone id    |


## Output

| Name | Decription |
|:----:|:----------:|
| id   | EFS id     |
| host | EFS host   |
