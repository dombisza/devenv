locals {
  prefix = "${var.owner}-${var.stage}"
  tags = {
    Stage   = var.stage
    Owner   = var.owner
    Managed_By = "terraform"
  }
}

module "key" {
  source = "./key"
  prefix = local.prefix
}

module "vpc" {
  source = "./vpc"
  prefix = local.prefix
  tags = local.tags
  region = var.region
}

module "natgw" {
  source = "./natgw"
  prefix = local.prefix
  vpc_id = module.vpc.vpc_id
  network_id = module.vpc.network_id
  cidr = module.vpc.cidr
}

module "bastion" {
  source = "./bastion"
  prefix = local.prefix
  tags = local.tags
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  network_id = module.vpc.network_id
  az = "eu-de-01"
  key_name = module.key.key_name
}

module "cce" {
  source = "./cluster"
  prefix = local.prefix
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  node_flavor = "s3.xlarge.2"
  key_name = module.key.key_name
  scale_enabled = true 
  node_os = "HCE OS 2.0"
  #cnt = "vpc-router"
  cnt = "overlay_l2"
  cluster_version = "v1.30"
}

# module "dns" {
  # source = "./dns"
  # domain = "sdombi.hu."
  # email = "dombisza@gmail.com"
  # sub_domain = "obs"
  # elb_ip = "164.30.70.79"
# }
