resource "openstack_networking_port_v2" "port_1" {
  name           = var.port_name
  region         = var.region_name
  network_id     = var.network_id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = var.subnet_id
    ip_address = cidrhost(var.subnet_cidr, 1)
  }

  allowed_address_pairs {
    ip_address = "0.0.0.0/0"
  }
}

resource "openstack_compute_interface_attach_v2" "port_attach_1" {
  region      = var.region_name
  port_id     = openstack_networking_port_v2.port_1.id
  instance_id = var.srv_id
}
