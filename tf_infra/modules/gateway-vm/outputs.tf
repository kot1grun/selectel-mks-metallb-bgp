output "srv_name" {
  value = openstack_compute_instance_v2.this.name
}
output "srv_id" {
  value = openstack_compute_instance_v2.this.id
}

output "srv_int_net_port_id" {
  value = openstack_networking_port_v2.srv_int_net_port.id
}
