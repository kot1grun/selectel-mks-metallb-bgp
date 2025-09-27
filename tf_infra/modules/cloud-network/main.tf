locals {
  gw_ip = cidrhost(var.subnet_cidr, var.gw_last_octet)
}

# Внешняя сеть floating-ов (получение идентификатора)
data "openstack_networking_network_v2" "external_net" {
  name     = var.external_net
  region   = var.region_name
  external = true
}

# Сеть
resource "openstack_networking_network_v2" "this" {
  name                  = var.network_name
  region                = var.region_name
  admin_state_up        = "true"
  port_security_enabled = "true"
}

# Подсеть
resource "openstack_networking_subnet_v2" "this" {
  name            = "${openstack_networking_network_v2.this.name}-subnet-1"
  region          = var.region_name
  network_id      = openstack_networking_network_v2.this.id
  cidr            = var.subnet_cidr
  dns_nameservers = var.dns_nameservers
  enable_dhcp     = "false"
  gateway_ip      = local.gw_ip

  allocation_pool {
    start = cidrhost(var.subnet_cidr, 10)
    end   = cidrhost(var.subnet_cidr, -6)
  }
}

# Роутер для сети
resource "openstack_networking_port_v2" "this" {
  region     = var.region_name
  network_id = openstack_networking_network_v2.this.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.this.id
    ip_address = cidrhost(var.subnet_cidr, 1)
  }

}

resource "openstack_networking_router_v2" "this" {
  name                = "${openstack_networking_network_v2.this.name}-main-rtr"
  region              = var.region_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_net.id
}

# Внутренний порт для роутера
resource "openstack_networking_router_interface_v2" "this" {
  region    = var.region_name
  router_id = openstack_networking_router_v2.this.id
  port_id   = openstack_networking_port_v2.this.id
}
