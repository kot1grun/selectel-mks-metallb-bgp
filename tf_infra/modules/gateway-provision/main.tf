resource "ansible_playbook" "this" {
  playbook   = "${path.root}/../ansible/gateway_vm_provision.yml"
  name       = var.srv_public_ip
  replayable = var.is_provision_replayable

  # timeouts {
  #   create = "360s"
  # }

  extra_vars = {
    ansible_host_key_checking = var.check_host_ssh_key
    my_hostname               = var.srv_name
    provider                  = var.cloud_name
    region                    = var.region
    anycast_subnet            = var.anycast_cidr
    provider_asn              = var.provider_asn
    my_asn                    = var.my_pa_asn
    my_ip_address             = var.srv_public_ip
    peer_ip_address           = var.peer_ip
    my_local_subnet           = var.internal_subnet
    my_internal_iface         = "eth1"
    my_external_iface         = "eth0"
  }
}
