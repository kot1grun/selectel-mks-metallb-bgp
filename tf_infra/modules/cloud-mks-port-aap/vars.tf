# Аутентификация
variable "username" {

}

variable "password" {
  sensitive = true
}

variable "auth_url" {

}

# Данные по проекту
variable "user_domain_name" {

}

variable "project_name" {

}

variable "project_id" {

}

variable "project_domain_name" {

}

# Пул
variable "region_name" {

}

variable "network_id" {

}

variable "mks_cluster_id" {

}

variable "worker_nodes_ips" {
  type = list(string)
}

variable "allowed_subnets" {
  type = list(string)
}

variable "is_replayable" {
  type    = bool
  default = true
}
