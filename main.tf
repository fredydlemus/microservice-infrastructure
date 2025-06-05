module "vpc"{
    source = "terraform-aws-modules/vpc/aws"
    version = "2.47.0"
    
    name = "${var.cluster_name}-vpc"
    cidr = var.vpc_cidr
    azs = slice(data.aws_availability_zones.available.names, 0, 3)
    public_subnets = var.public_subnet_cidrs
    private_subnets = var.private_subnet_cidrs

    enable_nat_gateway = true
    single_nat_gateway = true

    tags = {
        "Name" = "${var.cluster_name}-vpc"
    }
}

data "aws_availability_zones" "available" {}

module "eks"{
    source = "terraform-aws-modules/eks/aws"
    version = "25.1.0"

    cluster_name = var.cluster_name
    cluster_version = "1.27"
    subnets = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id

    cluster_enabled_log_types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler"
    ]

    node_groups = {
        default_nodes = {
            desired_capacity = var.node_group_desired_capacity
            max_capacity     = var.node_group_desired_capacity + 1
            min_capacity     = var.node_group_desired_capacity
            
            instance_types = [var.node_group_instance_type]
            key_name = ""
            disk_size = 20

            additional_tags = {
                Name = "${var.cluster_name}-node"
            }
        }
    }

    manage_aws_auth = true

    tags = {
        "Environment" = "dev"
        "Terraform"   = "true"
    }
}