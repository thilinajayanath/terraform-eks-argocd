# Bootstrapping Kubernetes (EKS) with Argo CD using terraform
This github repo is related to the medium article https://thilinajnl.medium.com/bootstrapping-kubernetes-aws-eks-with-argo-cd-using-terraform-b42d28429b4e

## Rerquirements
- Configured AWS profile with permissions to create the required resources
- Terraform (Code was tested on version 1.5.2)
- AWS, Helm, and Kubernetes terraform providers

## Resources created
- VPC with public and private subnets
- IAM roles and instance profile
- NAT and Internet Gateways 
- EKS cluster
- EC2 instances using auto-scaling groups for Kubernetes worker nodes
- Namespace in Kubernetes for Argo CD
- Argo CD deployment in Kubernetes
