locals {
  allowed_subnets_arg = join(",", var.allowed_subnets)
}

# Идентификаторы портов
data "openstack_networking_port_v2" "this" {
  for_each   = { for i, v in var.worker_nodes_ips : i => v }
  region     = var.region_name
  network_id = var.network_id
  fixed_ip   = each.value
  tags       = ["mks_cluster=true", "mks_cluster_id=${var.mks_cluster_id}"]
}

# К сожалению, запуск с локальным соединением не отрабатывает:
# не находится необходимый модуль openstacksdk.
# Возможно, это связано с проблемами с установкой компонентов на MacOS
# с использованием brew. 
# resource "ansible_playbook" "this" {
#   for_each   = data.openstack_networking_port_v2.this
#   playbook   = "${path.root}/../ansible/playbooks/openstack_aap.yaml"
#   name       = "localhost"
#   replayable = var.is_replayable

#   extra_vars = {
#     # ansible_hostname    = "localhost"
#     # ansible_connection  = "local"
#     auth_url            = var.auth_url
#     username            = var.username
#     password            = var.password
#     user_domain_name    = var.user_domain_name
#     project_name        = var.project_name
#     project_id          = var.project_id
#     project_domain_name = var.project_domain_name
#     region_name         = var.region_name
#     allowed_subnets     = jsonencode(var.allowed_subnets)
#     port_id             = each.value.port_id
#   }
# }

# Добавление AAP к портам (workaround для закомментированной секции выше)
# Замена null_resource в актуальных версиях Terraform
resource "terraform_data" "this" {
  for_each         = data.openstack_networking_port_v2.this
  triggers_replace = timestamp()
  provisioner "local-exec" {
    command = "ansible-playbook -e network_id=${var.network_id} -e port_id=${each.value.port_id} -e allowed_subnets=\"${local.allowed_subnets_arg}\" ${path.root}/../ansible/openstack_aap.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      OS_AUTH_URL               = "${var.auth_url}"
      OS_PROJECT_DOMAIN_NAME    = "${var.project_domain_name}"
      OS_PROJECT_ID             = "${var.project_id}"
      OS_TENANT_ID              = "${var.project_id}"
      OS_REGION_NAME            = "${var.region_name}"
      OS_USER_DOMAIN_NAME       = "${var.user_domain_name}"
      OS_USERNAME               = "${var.username}"
      OS_PASSWORD               = "${var.password}"
    }
  }
}
