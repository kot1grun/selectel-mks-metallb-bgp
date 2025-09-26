terraform {
  required_providers {
    helm = {
      source                = "hashicorp/helm"
      version               = ">= 3.0"
      configuration_aliases = [helm.mks]
    }
  }
}

