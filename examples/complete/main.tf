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

  efs_backup_policy_enabled       = true

  associated_security_group_ids   = [module.efs_security_group.id]
  create_security_group           = false

  transition_to_ia = ["AFTER_7_DAYS"]

  security_group_create_before_destroy = false

  context = module.this.context
}

  module "efs_security_group" {
  source = "cloudposse/security-group/aws"

  name                       = "prod_efs_security_group"
  security_group_name        = ["prod_efs_security_group"]
  security_group_description = "Security Group for EFS for prod hosts"
  vpc_id                     = module.vpc.vpc_id

  rules = [
    {
      type                     = "ingress"
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "TCP"
      source_security_group_id = module.vpc.vpc_default_security_group_id
      description              = "Allow EC2 instances to get access on EFS over port 2049"
    }
  ]
}
