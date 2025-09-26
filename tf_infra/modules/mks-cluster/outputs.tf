output "mks_cluster_id" {
  value = selectel_mks_cluster_v1.mks_cluster_1.id
}

output "mks_kubeconfig" {
  value = data.selectel_mks_kubeconfig_v1.kubeconfig_1.raw_config
}

output "mks_cluster_key" {
  value = data.selectel_mks_kubeconfig_v1.kubeconfig_1.client_key
}

output "mks_cluster_cert" {
  value = data.selectel_mks_kubeconfig_v1.kubeconfig_1.client_cert
}

output "mks_cluster_cacert" {
  value = data.selectel_mks_kubeconfig_v1.kubeconfig_1.cluster_ca_cert
}

output "mks_cluster_api_url" {
  value = data.selectel_mks_kubeconfig_v1.kubeconfig_1.server
}

output "worker_nodes" {
  value = selectel_mks_nodegroup_v1.mks_nodegroup_1.nodes
}
