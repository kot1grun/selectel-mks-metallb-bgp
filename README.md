# Selectel Managed Kubernetes Services + MetalLB in L3 mode + BGP

Проект представляет набор манифестов Terraform для развертывания демо-стенда инфраструктуры с управляемым Kubernetes и балансирощиком MetalLB, работающем в режиме layer 3 и анонсированием адресов по BGP.

## Что необходимо создать заранее?

1. Линковочные подсети с публичными адресами в двух разных пулах.
2. Тикет в техническую поддержку.
   В тикете нужно указать:

- пулы, для которых нужно настроить единую адресацию;
- для каждого из пулов - IP-адрес из линковочной подсети этого пула. Эти адреса будут использоваться в качестве BGP neighbor;
- желаемую размерность anycast-подсети от /32 до /24, в примере используется /29;

После получения ответа можно развертывать инфраструктуру IaC-ом.

## Что создается в инфраструктуре:

1. Сети и приватные подсети в двух разных пулах.
2. По одной ВМ с интерфейсом и адресом во внешней линковочной сети в двух разных пулах.
3. Два кластера Kubernetes в разных пулах.

## Как настраивается ВМ:

1. Обновляются пакеты и устанавливаются недостающие.
2. Выключается cloud-init для конфигурации сети.
3. Включается форвардинг пакетов IPv4.
4. Настраивается netfilter/nftables.
5. Добавляется репозиторий frr.
6. Устанавиливается frr из репозитория.
7. Настраивается запуск bgpd.
8. В frr настраивается BGP neighbor.

## Как это запустить?

1. Установить все необходимые программы и утилиты.
   На управляющей машине необходим [terraform](https://developer.hashicorp.com/terraform/install), [ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html).

   Дополнительно следует проверить, что в ansible установлена коллекция openstack.cloud (требует openstacksdk >= 1.0.0)

```shell
ansible-galaxy collection list | grep "openstack.cloud"
```

2. Клонировать репозиторий.

```shell
git clone https://github.com/kot1grun/selectel-mks-metallb-bgp.git
```

3. Перейти в каталог tf_infra.

```shell
cd tf_infra
```

4. Скопировать terraform.tfvars_example и внести изменения в соответствии со своими данными, в том числе полученными от технической поддержки.

```
cp terraform.tfvars_example terraform.tfvars
```

5. Создать файл ansible/roles/gateway-vm/vars/main.yml и переопределить в нем переменные (списки) trusted_ips и additional_trusted_ips при необходимости.

6. Выполнить:

```shell
terraform init
terraform plan
terraform apply -target=terraform_data.ridge_one
terraform apply -target=terraform_data.ridge_two
terraform apply
```

Обратите внимание, что развертывание происходить в три этапа.

## Как проверить работоспособность?

_;TBD_
