output "srv_name" {
  value = openstack_compute_instance_v2.server_1.name
}
output "srv_id" {
  value = openstack_compute_instance_v2.server_1.id
}

output "srv_int_net_port_id" {
  value = openstack_networking_port_v2.srv_int_net_port.id
}
