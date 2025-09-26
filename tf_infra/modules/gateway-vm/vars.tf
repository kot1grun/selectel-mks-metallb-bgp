variable "availability_zone" {

}

variable "srv_name" {
  type    = string
  default = "please-change-me"
}

variable "srv_flavor" {
  type = string
}

variable "srv_disk_type" {
  type    = string
  default = "universal"
}

variable "srv_disk_size_gigabytes" {
  type    = number
  default = 5
}

variable "srv_os_image" {
  type    = string
  default = "Ubuntu 22.04 LTS 64-bit"
}

variable "internal_network_id" {

}

variable "external_network_id" {

}

variable "internal_subnet_id" {

}

variable "external_subnet_id" {

}

variable "int_subnet_cidr" {

}

variable "ip_last_octet" {

}

variable "srv_public_ip" {

}
variable "srv_ssh_key" {

}
