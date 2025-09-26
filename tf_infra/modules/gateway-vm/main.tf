locals {
  region_name = substr(var.availability_zone, 0, 4)
}

# Образ ОС (получение идентификатора)
data "openstack_images_image_v2" "srv_os_lts" {
  region      = local.region_name
  name        = var.srv_os_image
  most_recent = true
}

# Диск для ВМ
resource "openstack_blockstorage_volume_v3" "srv_volume_1" {
  name              = "volume-for-${var.srv_name}-1"
  region            = local.region_name
  availability_zone = var.availability_zone
  size              = var.srv_disk_size_gigabytes
  image_id          = data.openstack_images_image_v2.srv_os_lts.id
  volume_type       = "${var.srv_disk_type}.${var.availability_zone}"

  lifecycle {
    ignore_changes = [image_id]
  }
}

# Внешний порт для ВМ
resource "openstack_networking_port_v2" "srv_ext_net_port" {
  name       = "${var.srv_name}-eth0"
  region     = local.region_name
  network_id = var.external_network_id

  fixed_ip {
    subnet_id  = var.external_subnet_id
    ip_address = var.srv_public_ip
  }
}

# Внутренний порт для ВМ
resource "openstack_networking_port_v2" "srv_int_net_port" {
  name       = "${var.srv_name}-eth1"
  region     = local.region_name
  network_id = var.internal_network_id

  fixed_ip {
    subnet_id  = var.internal_subnet_id
    ip_address = cidrhost(var.int_subnet_cidr, var.ip_last_octet)
  }

  allowed_address_pairs {
    ip_address = "0.0.0.0/0"
  }
}

# ВМ
resource "openstack_compute_instance_v2" "server_1" {
  name              = var.srv_name
  region            = local.region_name
  availability_zone = var.availability_zone
  flavor_id         = var.srv_flavor
  key_pair          = var.srv_ssh_key

  network {
    port = openstack_networking_port_v2.srv_ext_net_port.id
  }

  network {
    port = openstack_networking_port_v2.srv_int_net_port.id
  }

  block_device {
    uuid             = openstack_blockstorage_volume_v3.srv_volume_1.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }


  metadata = {
    x_sel_server_default_addr = "{\"ipv4\":\"${openstack_networking_port_v2.srv_ext_net_port.all_fixed_ips.0}\"}"
  }
  vendor_options {
    ignore_resize_confirmation = true
  }
}
