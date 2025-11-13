module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security_group"
  
  # These are the ARGUMENT NAMES - they MUST match the security group module's variable names
  vpc_id = module.vpc.vpc_id          
}