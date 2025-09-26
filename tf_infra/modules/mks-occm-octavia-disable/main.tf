locals {
  occm_cfg_previous = base64decode(data.kubernetes_secret_v1.occm_cfg_previous.binary_data["cloud.conf"])
  occm_cfg_current  = replace(local.occm_cfg_previous, "[LoadBalancer]", "[LoadBalancer]\nenabled=false")
}

resource "time_static" "restarted_at" {}

# Текущая конфигурация OpenStack Cloud Controller Manager
data "kubernetes_secret_v1" "occm_cfg_previous" {
  provider = kubernetes.mks
  metadata {
    name      = "cloud-config"
    namespace = "kube-system"
  }
  binary_data = {
    "cloud.conf" = ""
  }
}

# Применение новой конфигурация OpenStack Cloud Controller Manager
resource "kubernetes_secret_v1_data" "occm_cfg_current" {
  provider = kubernetes.mks
  force    = true
  metadata {
    name      = "cloud-config"
    namespace = "kube-system"
  }
  data = {
    "cloud.conf" = base64encode(local.occm_cfg_current)
    # canary       = "Just to detect changes"
  }
}

# Для воспроизведения поведения kubectl rollout restart
resource "kubernetes_annotations" "occm_cfg_current_apply" {
  provider    = kubernetes.mks
  api_version = "apps/v1"
  kind        = "Deployment"
  metadata {
    name      = "openstack-cloud-controller-manager"
    namespace = "kube-system"
  }
  template_annotations = {
    "kubectl.kubernetes.io/restartedAt" = time_static.restarted_at.rfc3339
  }
  depends_on = [kubernetes_secret_v1_data.occm_cfg_current]
}
