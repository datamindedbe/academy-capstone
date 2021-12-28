module "vpc" {
  source = "./vpc"
  environment = local.env_name
  vpc_cidr = "10.1.0.0/16"
  azs = [
    "eu-west-1c", "eu-west-1a"]
  private_subnet_cidrs = [
    "10.1.3.0/24",
    "10.1.4.0/24"]
  public_subnet_cidrs = [
    "10.1.103.0/24"]
}

module "batch" {
  source = "./batch"
  env_name                = local.env_name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  allowed_cidrs           = [module.vpc.vpc_cidr_block]
  account_id = local.account_id
}
