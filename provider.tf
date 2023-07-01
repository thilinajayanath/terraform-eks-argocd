terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
  required_version = "1.5.2"
}

provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.test.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.test.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.test.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.test.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.test.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.test.token
  }
}
