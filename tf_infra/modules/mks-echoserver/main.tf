# Развертывание сервиса
resource "kubernetes_manifest" "deployment_cilium_echoserver" {
  provider = kubernetes.mks
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "cilium-echoserver"
      namespace = var.namespace
    }
    spec = {
      replicas = var.replicas
      selector = {
        matchLabels = {
          app = "cilium-echoserver"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "cilium-echoserver"
          }
        }
        spec = {
          containers = [
            {
              env = [
                {
                  name  = "PORT"
                  value = "8080"
                },
              ]
              image           = "cilium/echoserver:latest"
              imagePullPolicy = "IfNotPresent"
              name            = "cilium-echoserver"
              ports = [
                {
                  containerPort = 8080
                  protocol      = "TCP"
                },
              ]
            },
          ]
        }
      }
    }
  }
}

# Публикация сервиса
resource "kubernetes_manifest" "service_cilium_echo_svc_metallb" {
  provider = kubernetes.mks
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      annotations = {
        "loadbalancer.openstack.org/class" = "non-existent"
        "metallb.io/address-pool"          = "anycast-pool"
        "metallb.io/loadBalancerIPs"       = var.svc_ip
      }
      name      = "cilium-echo-svc-metallb"
      namespace = var.namespace
    }
    spec = {
      ports = [
        {
          name       = "http"
          port       = 80
          protocol   = "TCP"
          targetPort = 8080
        },
      ]
      selector = {
        app = "cilium-echoserver"
      }
      type = "LoadBalancer"
    }
  }
}
