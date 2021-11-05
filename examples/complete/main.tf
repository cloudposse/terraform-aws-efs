provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.28.0"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.39.7"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "efs" {
  source = "../../"

  region  = var.region
  vpc_id  = module.vpc.vpc_id
  subnets = module.subnets.private_subnet_ids
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

  security_group_suffix = var.security_group_suffix

  transition_to_primary_storage_class = "AFTER_1_ACCESS"

  context = module.this.context
}
