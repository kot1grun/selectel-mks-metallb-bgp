# Описание провайдеров
terraform {
  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = ">= 6.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 2.1.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
  }
  required_version = ">= 1.2"
}
