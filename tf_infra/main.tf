locals {
  region_alfa  = substr(var.availability_zone_alfa, 0, 4)
  region_bravo = substr(var.availability_zone_bravo, 0, 4)
}

data "openstack_networking_subnet_v2" "link_subnet_alfa" {
  region = local.region_alfa
  name   = var.alfa_link_subnet
  cidr   = var.alfa_link_subnet
}

data "openstack_networking_subnet_v2" "link_subnet_bravo" {
  region = local.region_bravo
  name   = var.bravo_link_subnet
  cidr   = var.bravo_link_subnet
}

module "net_alfa" {
  source        = "./modules/cloud-network"
  region_name   = local.region_alfa
  network_name  = "network-alfa"
  subnet_cidr   = var.alfa_internal_subnet
  gw_last_octet = 254
}

module "net_bravo" {
  source        = "./modules/cloud-network"
  region_name   = local.region_bravo
  network_name  = "network-bravo"
  subnet_cidr   = var.bravo_internal_subnet
  gw_last_octet = 254
}

module "ssh_key_alfa" {
  source           = "./modules/ssh-key"
  ssh_keypair_name = "my-${local.region_alfa}-key-for-infra"
  region_name      = local.region_alfa
}

module "ssh_key_bravo" {
  source           = "./modules/ssh-key"
  ssh_keypair_name = "my-${local.region_bravo}-key-for-infra"
  region_name      = local.region_bravo
}

module "gateway_vm_alfa" {
  source                  = "./modules/gateway-vm"
  availability_zone       = var.availability_zone_alfa
  srv_name                = "gateway-alfa-unoone"
  srv_flavor              = 9053 # PRC50.2-2048
  srv_disk_size_gigabytes = 16
  srv_disk_type           = "basicssd"
  srv_os_image            = var.os_image
  srv_ssh_key             = module.ssh_key_alfa.key_name
  internal_network_id     = module.net_alfa.network_id
  external_network_id     = data.openstack_networking_subnet_v2.link_subnet_alfa.network_id
  internal_subnet_id      = module.net_alfa.subnet_id
  external_subnet_id      = data.openstack_networking_subnet_v2.link_subnet_alfa.id
  int_subnet_cidr         = module.net_alfa.subnet_cidr
  ip_last_octet           = 254
  srv_public_ip           = var.alfa_my_neighbour_ip
}

module "gateway_vm_bravo" {
  source                  = "./modules/gateway-vm"
  availability_zone       = var.availability_zone_bravo
  srv_name                = "gateway-bravo-bissotwo"
  srv_flavor              = 1012 # SL1.1-2048
  srv_disk_size_gigabytes = 16
  srv_disk_type           = "basicssd"
  srv_os_image            = var.os_image
  srv_ssh_key             = module.ssh_key_bravo.key_name
  internal_network_id     = module.net_bravo.network_id
  external_network_id     = data.openstack_networking_subnet_v2.link_subnet_bravo.network_id
  internal_subnet_id      = module.net_bravo.subnet_id
  external_subnet_id      = data.openstack_networking_subnet_v2.link_subnet_bravo.id
  int_subnet_cidr         = module.net_bravo.subnet_cidr
  ip_last_octet           = 254
  srv_public_ip           = var.bravo_my_neighbour_ip
}

module "gtw_provision_alfa" {
  source                  = "./modules/gateway-provision"
  region                  = local.region_alfa
  is_provision_replayable = false
  anycast_cidr            = var.anycast_cidr
  provider_asn            = var.alfa_provider_asn
  my_pa_asn               = var.my_pa_asn
  srv_name                = module.gateway_vm_alfa.srv_name
  srv_public_ip           = var.alfa_my_neighbour_ip
  peer_ip                 = cidrhost(var.alfa_link_subnet, 1)
  internal_subnet         = module.net_alfa.subnet_cidr
}

module "gtw_provision_bravo" {
  source                  = "./modules/gateway-provision"
  region                  = local.region_bravo
  is_provision_replayable = false
  anycast_cidr            = var.anycast_cidr
  provider_asn            = var.bravo_provider_asn
  my_pa_asn               = var.my_pa_asn
  srv_name                = module.gateway_vm_bravo.srv_name
  srv_public_ip           = var.bravo_my_neighbour_ip
  peer_ip                 = cidrhost(var.bravo_link_subnet, 1)
  internal_subnet         = module.net_bravo.subnet_cidr
}

module "mks_cluster_alfa" {
  source            = "./modules/mks-cluster"
  project_id        = var.project_id
  availability_zone = var.availability_zone_alfa
  mks_cluster_name  = "k8s-alfa-unoone"
  network_id        = module.net_alfa.network_id
  subnet_id         = module.net_alfa.subnet_id
  ssh_keypair_name  = module.ssh_key_alfa.key_name
  nodes_count       = var.nodes_count_alfa
  node_flavor       = 1013 # 1013 <- SL1.2-4096, 9054 <- PRC50.2-4096
  node_volume_type  = "basicssd"
  node_volume_size  = 40

  depends_on = [module.gtw_provision_alfa]
}

module "mks_cluster_bravo" {
  source            = "./modules/mks-cluster"
  project_id        = var.project_id
  availability_zone = var.availability_zone_bravo
  mks_cluster_name  = "k8s-bravo-bissotwo"
  network_id        = module.net_bravo.network_id
  subnet_id         = module.net_bravo.subnet_id
  ssh_keypair_name  = module.ssh_key_bravo.key_name
  nodes_count       = var.nodes_count_bravo
  node_flavor       = 1013 # 1013 <- SL1.2-4096, 9054 <- PRC50.2-4096
  node_volume_type  = "basicssd"
  node_volume_size  = 40

  depends_on = [module.gtw_provision_bravo]
}

resource "terraform_data" "ridge_one" {

  provisioner "local-exec" {
    command = "echo '=== I am only a ridge ONE right now... ==='"
  }

  depends_on = [module.mks_cluster_alfa, module.mks_cluster_bravo]
}

module "metallb_install_alfa" {
  source = "./modules/mks-metallb-install"
  providers = {
    helm.mks = helm.alfa
  }
  depends_on = [module.mks_cluster_alfa]
}

module "metallb_install_bravo" {
  source = "./modules/mks-metallb-install"
  providers = {
    helm.mks = helm.bravo
  }
  depends_on = [module.mks_cluster_bravo]
}

resource "terraform_data" "ridge_two" {

  provisioner "local-exec" {
    command = "echo '=== I am only a ridge TWO right now... ==='"
  }

  depends_on = [module.metallb_install_alfa, module.metallb_install_bravo]
}

module "occm_settings_alfa" {
  source = "./modules/mks-occm-octavia-disable"
  providers = {
    kubernetes.mks = kubernetes.alfa
  }
  depends_on = [module.mks_cluster_alfa]
}

module "occm_settings_bravo" {
  source = "./modules/mks-occm-octavia-disable"
  providers = {
    kubernetes.mks = kubernetes.bravo
  }
  depends_on = [module.mks_cluster_bravo]
}

module "metallb_settings_alfa" {
  source = "./modules/mks-metallb-l3"
  providers = {
    kubernetes.mks = kubernetes.alfa
  }
  peer_name    = "gateway-alfa-unoone"
  peer_ip      = cidrhost(var.alfa_internal_subnet, 254)
  my_pa_asn    = var.my_pa_asn
  anycast_cidr = var.anycast_cidr
  depends_on   = [module.mks_cluster_alfa, module.metallb_install_alfa]
}

module "metallb_settings_bravo" {
  source = "./modules/mks-metallb-l3"
  providers = {
    kubernetes.mks = kubernetes.bravo
  }
  peer_name    = "gateway-bravo-bissotwo"
  peer_ip      = cidrhost(var.bravo_internal_subnet, 254)
  my_pa_asn    = var.my_pa_asn
  anycast_cidr = var.anycast_cidr
  depends_on   = [module.mks_cluster_bravo, module.metallb_install_bravo]
}

module "echo_server_alfa" {
  source = "./modules/mks-echoserver"
  providers = {
    kubernetes.mks = kubernetes.alfa
  }
  svc_ip     = cidrhost(var.anycast_cidr, 1)
  depends_on = [module.mks_cluster_alfa, module.metallb_settings_alfa]
}

module "echo_server_bravo" {
  source = "./modules/mks-echoserver"
  providers = {
    kubernetes.mks = kubernetes.bravo
  }
  svc_ip     = cidrhost(var.anycast_cidr, 2)
  depends_on = [module.mks_cluster_bravo, module.metallb_settings_bravo]
}

module "mks_worker_nodes_aap_alfa" {
  source              = "./modules/cloud-mks-port-aap"
  auth_url            = var.auth_url
  username            = var.username
  password            = var.password
  user_domain_name    = var.user_domain_name
  project_name        = var.project_name
  project_id          = var.project_id
  project_domain_name = var.project_domain_name
  region_name         = local.region_alfa
  mks_cluster_id      = module.mks_cluster_alfa.mks_cluster_id
  network_id          = module.net_alfa.network_id
  worker_nodes_ips    = module.mks_cluster_alfa.worker_nodes[*].ip
  allowed_subnets     = [var.anycast_cidr, "10.96.0.0/12"]

}

module "mks_worker_nodes_aap_bravo" {
  source              = "./modules/cloud-mks-port-aap"
  auth_url            = var.auth_url
  username            = var.username
  password            = var.password
  user_domain_name    = var.user_domain_name
  project_name        = var.project_name
  project_id          = var.project_id
  project_domain_name = var.project_domain_name
  region_name         = local.region_bravo
  mks_cluster_id      = module.mks_cluster_bravo.mks_cluster_id
  network_id          = module.net_bravo.network_id
  worker_nodes_ips    = module.mks_cluster_bravo.worker_nodes[*].ip
  allowed_subnets     = [var.anycast_cidr, "10.96.0.0/12"]

}
