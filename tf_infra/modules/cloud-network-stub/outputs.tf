output "network_id" {
  value = openstack_networking_network_v2.cloud_net_1.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.cloud_subnet_1.id
}

output "subnet_cidr" {
  value = openstack_networking_subnet_v2.cloud_subnet_1.cidr
}
