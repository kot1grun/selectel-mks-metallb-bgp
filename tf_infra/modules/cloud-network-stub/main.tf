# Сеть (без роутера)
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
  gateway_ip      = cidrhost(var.subnet_cidr, 1)
  dns_nameservers = var.dns_nameservers
  enable_dhcp     = "false"
}
