# Описание провайдера
terraform {
  required_providers {
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = ">= 2.35.1"
      configuration_aliases = [kubernetes.mks]
    }
  }
}
