resource "helm_release" "metallb" {
  provider         = helm.mks
  name             = "metallb"
  version          = var.metallb_version
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  create_namespace = true
  namespace        = "metallb-system"
  replace          = true
}
