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
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora Reader Endpoint"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}