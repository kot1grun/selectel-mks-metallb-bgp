variable "region_name" {

}

variable "network_name" {

}

variable "external_net" {
  default = "external-network"

}

variable "subnet_cidr" {

}

variable "gw_last_octet" {
  default = 1
}

variable "dns_nameservers" {
  default = [
    "188.93.16.19",
    "188.93.17.19",
  ]
}
