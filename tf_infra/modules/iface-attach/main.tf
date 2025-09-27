resource "openstack_networking_port_v2" "this" {
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

resource "openstack_compute_interface_attach_v2" "this" {
  region      = var.region_name
  port_id     = openstack_networking_port_v2.this.id
  instance_id = var.srv_id
}
