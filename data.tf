data "aws_iam_policy_document" "assume_role_eks" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_eks_cluster_auth" "test" {
  name = "test"
}

data "aws_eks_cluster" "test" {
  name = "test"

  depends_on = [aws_eks_cluster.test]
}

data "aws_caller_identity" "current" {}
