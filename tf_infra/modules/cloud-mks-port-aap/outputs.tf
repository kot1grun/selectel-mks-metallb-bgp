output "worker_nodes_ports" {
  value = values(data.openstack_networking_port_v2.this)[*].port_id
}

output "raw_ports_data" {
  value = data.openstack_networking_port_v2.this
}
