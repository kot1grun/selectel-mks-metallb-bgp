output "mks_cluster_alfa_kubeconfig" {
  value     = module.mks_cluster_alfa.mks_kubeconfig
  sensitive = true
}

output "mks_cluster_bravo_kubeconfig" {
  value     = module.mks_cluster_bravo.mks_kubeconfig
  sensitive = true
}
