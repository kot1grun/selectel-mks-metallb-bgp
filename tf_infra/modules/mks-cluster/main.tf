locals {
  region_name = substr(var.availability_zone, 0, 4)
}

# Получение актуальных версий k8s в MKS
data "selectel_mks_kube_versions_v1" "mks_versions" {
  project_id = var.project_id
  region     = local.region_name
}

# Кластер managed kubernetes services
resource "selectel_mks_cluster_v1" "mks_cluster_1" {
  name                              = var.mks_cluster_name
  region                            = local.region_name
  project_id                        = var.project_id
  network_id                        = var.network_id
  subnet_id                         = var.subnet_id
  kube_version                      = data.selectel_mks_kube_versions_v1.mks_versions.default_version
  zonal                             = !var.is_controlplane_highavailable
  enable_patch_version_auto_upgrade = false
}

# Группа нод в кластере
resource "selectel_mks_nodegroup_v1" "mks_nodegroup_1" {
  cluster_id                   = selectel_mks_cluster_v1.mks_cluster_1.id
  project_id                   = var.project_id
  region                       = local.region_name
  availability_zone            = var.availability_zone
  nodes_count                  = var.nodes_count
  keypair_name                 = var.ssh_keypair_name
  flavor_id                    = var.node_flavor
  volume_gb                    = var.node_volume_size
  volume_type                  = "${var.node_volume_type}.${var.availability_zone}"
  install_nvidia_device_plugin = false

  # labels          = var.labels
  # dynamic "taints" {
  #   for_each = var.taints[*]
  #   content {
  #     key    = taints.value["key"]
  #     value  = taints.value["value"]
  #     effect = taints.value["effect"]
  #   }
  # }
}

data "selectel_mks_kubeconfig_v1" "kubeconfig_1" {
  cluster_id = selectel_mks_cluster_v1.mks_cluster_1.id
  project_id = selectel_mks_cluster_v1.mks_cluster_1.project_id
  region     = selectel_mks_cluster_v1.mks_cluster_1.region
}
