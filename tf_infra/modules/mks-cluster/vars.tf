variable "project_id" {

}

variable "availability_zone" {

}

variable "network_id" {

}

variable "subnet_id" {

}

variable "mks_cluster_name" {
  default = "mks-default-cluster-name-to-change"
}

variable "nodes_count" {
  default = 1

}

variable "node_flavor" {

}

variable "node_volume_type" {

}

variable "node_volume_size" {
  default = 30 # <- минимально допустимое значение
}

variable "is_controlplane_highavailable" {
  default = false
}

variable "ssh_keypair_name" {

}


