module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name            = "${var.cluster_name}-vpc"
  cidr            = var.vpc_cidr
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = false
  single_nat_gateway = false

  tags = {
    "Name" = "${var.cluster_name}-vpc"
  }
}

data "aws_availability_zones" "available" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}