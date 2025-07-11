variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "node_group_desired_capacity" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "node_group_instance_type" {
  description = "Instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "fredy"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "password123"
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string
  default     = "db.t4g.medium"
}

variable "db_instances_count" {
  description = "Number of Aurora reader instances"
  type        = number
  default     = 2
}

variable "db_port" {
  description = "TCP port for the database"
  type        = number
  default     = 5432
}

variable "enable_aurora_db" {
  description = "Enable or disable the Aurora database"
  type        = bool
  default     = false
}