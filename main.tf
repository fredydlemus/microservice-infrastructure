module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name           = "${var.cluster_name}-vpc"
  cidr           = var.vpc_cidr
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets = var.public_subnet_cidrs

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

resource "aws_security_group" "aurora_sg" {
  name        = "${var.cluster_name}-aurora-sg"
  description = "Allow EKS -> Aurora potgress"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow EKS to access Aurora"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-aurora-sg"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name        = "${var.cluster_name}-aurora-subnet-group"
  subnet_ids  = module.vpc.public_subnets
  description = "Subnet group for Aurora DB instances"

  tags = {
    Name        = "${var.cluster_name}-aurora-subnet-group"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier = "${var.cluster_name}-aurora-cluster"
  engine             = "aurora-postgresql"
  engine_version     = "15.4"
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password
  port               = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  availability_zones  = module.vpc.azs
  skip_final_snapshot = true

  tags = {
    Name        = "${var.cluster_name}-aurora-cluster"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_rds_cluster_instance" "writer" {
  identifier          = "${var.cluster_name}-aurora-writer"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.db_instance_class
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = true

  tags = {
    Name        = "${var.cluster_name}-aurora-writer"
    Role        = "writer"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_rds_cluster_instance" "readers" {
  count               = var.db_instances_count
  identifier          = "${var.cluster_name}-aurora-reader-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.db_instance_class
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = true

  tags = {
    Name        = "${var.cluster_name}-aurora-reader-${count.index + 1}"
    Role        = "reader"
    Environment = "dev"
    Terraform   = "true"
  }
}