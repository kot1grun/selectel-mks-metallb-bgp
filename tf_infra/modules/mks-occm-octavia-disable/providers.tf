# Описание провайдеров
terraform {
  required_providers {
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = ">= 2.35.1"
      configuration_aliases = [kubernetes.mks]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13.0"
    }
  }
}
