module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  environment    = "dev"
}
