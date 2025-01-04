provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

terraform {
  backend "s3" {
    bucket         = "eks-tf-19159-bkt"  # Added missing closing quotation mark
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "eks-tf-19159-dyntbl"
  }
}

# Fetch the EKS Cluster details
#data "aws_eks_cluster" "my_cluster" {
#  name = aws_eks_cluster.my_cluster.name
#}

# Fetch the EKS Cluster authentication details
#data "aws_eks_cluster_auth" "my_cluster" {
#  name = aws_eks_cluster.my_cluster.name
#}

# Kubernetes provider configuration to authenticate with the EKS cluster
#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.my_cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)
#  token                  = data.aws_eks_cluster_auth.my_cluster.token
#}
