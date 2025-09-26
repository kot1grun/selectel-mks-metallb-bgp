# Имя пира для BGP-пиринга
variable "peer_name" {
  type    = string
  default = "please-change-me"
}

# IP-адрес пира, ожидается приватный адрес ВМ-шлюза
variable "peer_ip" {

}

# ASN, выделенная провайдером
variable "my_pa_asn" {

}

# Название пула в MetalLB для анонса
variable "ip_pool_name" {
  default = "anycast-pool"
}

# Выделенная anycast-подсеть
variable "anycast_cidr" {

}
