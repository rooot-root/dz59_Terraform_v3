# for_each-vm.tf
# Две ВМ для баз данных: main и replica, с разными характеристиками.
# Используется мета-аргумент for_each + общая переменная var.each_vm.

resource "yandex_compute_instance" "db" {
  # Преобразуем list(object) в map, где ключ — vm_name.
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  # Разрешает Terraform остановить ВМ для изменения ресурсов (cpu/ram).
  allow_stopping_for_update = true

  name = each.value.vm_name

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk_volume
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}