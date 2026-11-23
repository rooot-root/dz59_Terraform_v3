# disk_vm.tf

# 1. Создаём 3 одинаковых диска по 1 ГБ через count
resource "yandex_compute_disk" "storage_disk" {
  count = 3
  name  = "storage-disk-${count.index + 1}"
  size  = 1
  type  = "network-hdd"
  zone  = var.default_zone
}

# 2. Создаём ВМ "storage" (одиночную, без count/for_each)
resource "yandex_compute_instance" "storage" {
  name = "storage"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
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

  # 3. Подключаем диски через dynamic + for_each
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = true
    }
  }
}