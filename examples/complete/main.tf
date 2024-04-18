provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  ipv4_primary_cidr_block          = "172.16.0.0/16"
  assign_generated_ipv6_cidr_block = false

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "efs" {
  source = "../../"

  region  = var.region
  vpc_id  = module.vpc.vpc_id
  subnets = module.subnets.private_subnet_ids

  access_points = {
    "data" = {
      posix_user = {
        gid            = "1001"
        uid            = "5000"
        secondary_gids = "1002,1003"
      }
      creation_info = {
        gid         = "1001"
        uid         = "5000"
        permissions = "0755"
      }
    }
    "data2" = {
      posix_user = {
        gid            = "2001"
        uid            = "6000"
        secondary_gids = null
      }
      creation_info = {
        gid         = "123"
        uid         = "222"
        permissions = "0555"
      }
    }
  }

  additional_security_group_rules = [
    {
      type                     = "ingress"
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      cidr_blocks              = []
      source_security_group_id = module.vpc.vpc_default_security_group_id
      description              = "Allow ingress traffic to EFS from trusted Security Groups"
    }
  ]

  transition_to_ia      = ["AFTER_7_DAYS"]
  transition_to_archive = ["AFTER_60_DAYS"]

  security_group_create_before_destroy = false

  context = module.this.context
}
