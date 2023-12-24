output "cluster_endpoint" {
    description = "Endpoints of the API server"
    value = [for cluster in aws_eks_cluster.aws_eks : cluster.endpoint] 
}

output "cluster_name" {
    description = "Name of the Cluster can be retrieved from id"
    value = [for cluster in aws_eks_cluster.aws_eks : cluster.id] 
}

# output "oidc_url" {
#     description = "oidc provider url"
#     value = [for url in aws_iam_openid_connect_provider.oidc_cluster : url.url]
# }

# output "eks_cluster_identity_oidc_issuer_arn" {
#   description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
#   value = [for arn in aws_iam_openid_connect_provider.oidc_cluster : arn.arn ]
# }
