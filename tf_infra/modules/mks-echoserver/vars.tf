# IP-адрес дял сервиса
# Должен быть из пула ip_pool_name
variable "svc_ip" {

}

# Количество реплик приложения
variable "replicas" {
  default = 2
}

# Название пула в MetalLB для анонса
variable "ip_pool_name" {
  default = "anycast-pool"
}

variable "namespace" {
  default = "default"
}
