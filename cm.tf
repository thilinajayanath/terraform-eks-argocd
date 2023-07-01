resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/thilina"
        username = "thilina"
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
      {
        rolearn  = "${aws_iam_role.eks_cluster.arn}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
      }]
    )
  }

  lifecycle {
    # We are ignoring the data here since we will manage it with the resource below
    # This is only intended to be used in scenarios where the configmap does not exist
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
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/thilina"
        username = "thilina"
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
      /*{
        rolearn  = "${aws_iam_role.eks_cluster.arn}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
      }*/
    ])
  }

  depends_on = [
    # Required for instances where the configmap does not exist yet to avoid race condition
    kubernetes_config_map.aws_auth,
  ]
}
