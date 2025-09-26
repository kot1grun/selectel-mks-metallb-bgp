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

# Сегмент пула 1 
variable "availability_zone_alfa" {
  type = string
}

# Сегмент пула 2
variable "availability_zone_bravo" {
  type = string
}

# Выделенная anycast-подсеть
variable "anycast_cidr" {

}

# Используемый образ ОС
variable "os_image" {
  default = "Alma Linux 9 64-bit"
}

# Линковочыне публичные подсети
variable "alfa_link_subnet" {

}

variable "bravo_link_subnet" {

}

# Внутренние подсети
variable "alfa_internal_subnet" {

}

variable "bravo_internal_subnet" {

}

# IP-адреса провайдера для BGP-пиринга
variable "alfa_my_neighbour_ip" {

}

variable "bravo_my_neighbour_ip" {

}

# ASN провайдера
variable "alfa_provider_asn" {

}

variable "bravo_provider_asn" {

}

# ASN, выделенная провайдером
variable "my_pa_asn" {

}

# Количество worker-нод в кластере MKS
variable "nodes_count_alfa" {
  type    = number
  default = 2
}

variable "nodes_count_bravo" {
  type    = number
  default = 2
}
