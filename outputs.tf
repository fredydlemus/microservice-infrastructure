output "cluster_endpoint"{
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

output "kubeconfig" {
  description = "Kubeconfig file content"
  value = <<EOT
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.cluster_endpoint}
    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${module.eks.cluster_id}"
        - "--region"
        - "${var.aws_region}"
EOT
}
