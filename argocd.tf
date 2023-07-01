resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [aws_eks_cluster.test]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-5.36.11/argo-cd-5.36.11.tgz"
  namespace  = "argocd"
  depends_on = [kubernetes_namespace.argocd]
}
