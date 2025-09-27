output "mks_cluster_id" {
  value = selectel_mks_cluster_v1.this.id
}

output "mks_kubeconfig" {
  value = data.selectel_mks_kubeconfig_v1.this.raw_config
}

output "mks_cluster_key" {
  value = data.selectel_mks_kubeconfig_v1.this.client_key
}

output "mks_cluster_cert" {
  value = data.selectel_mks_kubeconfig_v1.this.client_cert
}

output "mks_cluster_cacert" {
  value = data.selectel_mks_kubeconfig_v1.this.cluster_ca_cert
}

output "mks_cluster_api_url" {
  value = data.selectel_mks_kubeconfig_v1.this.server
}

output "worker_nodes" {
  value = selectel_mks_nodegroup_v1.this.nodes
}
