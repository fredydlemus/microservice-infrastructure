output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluster Certificate Authority Data"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "security_group_id" {
  description = "Control Plane Security Group ID"
  value       = module.eks.cluster_security_group_id
}

output "aurora_writer_endpoint" {
  description = "Aurora Writer Endpoint"
  value       = var.enable_aurora_db ? aws_rds_cluster.aurora_cluster[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "Aurora Reader Endpoint"
  value       = var.enable_aurora_db ? aws_rds_cluster.aurora_cluster[0].reader_endpoint : null
}