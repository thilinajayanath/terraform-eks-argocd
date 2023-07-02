resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = data.aws_caller_identity.current.arn
        username = element(split("/", data.aws_arn.current_user.resource), length(split("/", data.aws_arn.current_user.resource)) - 1)
        groups   = ["system:masters"]
      },
    ])
    mapRoles = yamlencode([
      {
        rolearn  = "${aws_iam_role.eks_worker.arn}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
      },
    ])
  }

  lifecycle {
    ignore_changes = [data, metadata[0].labels, metadata[0].annotations]
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = data.aws_caller_identity.current.arn
        username = element(split("/", data.aws_arn.current_user.resource), length(split("/", data.aws_arn.current_user.resource)) - 1)
        groups   = ["system:masters"]
      },
    ])
    mapRoles = yamlencode([
      {
        rolearn  = "${aws_iam_role.eks_worker.arn}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
      },
    ])
  }

  depends_on = [
    kubernetes_config_map.aws_auth,
  ]
}
