# BGP-пиринг с ВМ роутером/шлюзом
resource "kubernetes_manifest" "bgppeer_metallb_system_vm_gateway" {
  provider = kubernetes.mks
  manifest = {
    apiVersion = "metallb.io/v1beta2"
    kind       = "BGPPeer"

    metadata = {
      name      = var.peer_name
      namespace = "metallb-system"
    }

    spec = {
      myASN       = var.my_pa_asn
      peerASN     = var.my_pa_asn
      peerAddress = var.peer_ip
    }
  }
}

# Пул адресов для балансировщиков
resource "kubernetes_manifest" "ipaddresspool_metallb_system_anycast_pool" {
  provider = kubernetes.mks
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"

    metadata = {
      name      = var.ip_pool_name
      namespace = "metallb-system"
    }

    spec = {
      addresses = [
        var.anycast_cidr,
      ]
    }
  }
}

# Анонсирование подсети для балансирощиков
resource "kubernetes_manifest" "bgpadvertisement_metallb_system_anycast_adv" {
  provider = kubernetes.mks
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "BGPAdvertisement"

    metadata = {
      name      = "anycast-adv"
      namespace = "metallb-system"
    }

    spec = {
      ipAddressPools = [
        var.ip_pool_name,
      ]
    }
  }
}
