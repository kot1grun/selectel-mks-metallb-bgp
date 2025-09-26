# Инициализация провайдера Selectel
provider "selectel" {
  username    = var.username
  password    = var.password
  domain_name = var.project_domain_name
}

# Инициализация провайдера OpenStack
provider "openstack" {
  auth_url            = var.auth_url
  user_name           = var.username
  tenant_name         = var.project_name
  password            = var.password
  project_domain_name = var.project_domain_name
  user_domain_name    = var.user_domain_name
  region              = var.region_name
}

# Инициализация провайдера kubernetes от hashicorp
# Кластер в регионе Alfa
provider "kubernetes" {
  alias                  = "alfa"
  host                   = module.mks_cluster_alfa.mks_cluster_api_url
  client_certificate     = base64decode(module.mks_cluster_alfa.mks_cluster_cert)
  client_key             = base64decode(module.mks_cluster_alfa.mks_cluster_key)
  cluster_ca_certificate = base64decode(module.mks_cluster_alfa.mks_cluster_cacert)
}

# Кластер в регионе Alfa
provider "kubernetes" {
  alias                  = "bravo"
  host                   = module.mks_cluster_bravo.mks_cluster_api_url
  client_certificate     = base64decode(module.mks_cluster_bravo.mks_cluster_cert)
  client_key             = base64decode(module.mks_cluster_bravo.mks_cluster_key)
  cluster_ca_certificate = base64decode(module.mks_cluster_bravo.mks_cluster_cacert)
}

# Инициализация провайдера helm от hashicorp
# Helm для кластера в регионе Alfa
provider "helm" {
  alias = "alfa"
  kubernetes = {
    host                   = module.mks_cluster_alfa.mks_cluster_api_url
    client_certificate     = base64decode(module.mks_cluster_alfa.mks_cluster_cert)
    client_key             = base64decode(module.mks_cluster_alfa.mks_cluster_key)
    cluster_ca_certificate = base64decode(module.mks_cluster_alfa.mks_cluster_cacert)
  }
}

# Helm для кластера в регионе Bravo
provider "helm" {
  alias = "bravo"
  kubernetes = {
    host                   = module.mks_cluster_bravo.mks_cluster_api_url
    client_certificate     = base64decode(module.mks_cluster_bravo.mks_cluster_cert)
    client_key             = base64decode(module.mks_cluster_bravo.mks_cluster_key)
    cluster_ca_certificate = base64decode(module.mks_cluster_bravo.mks_cluster_cacert)
  }
}
