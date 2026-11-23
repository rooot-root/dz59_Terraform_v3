# count-vm.tf
# Две одинаковые ВМ web-1 и web-2 через мета-аргумент count.
# Привязана группа безопасности example_dynamic (локальное имя ресурса — example).
# Создаются ПОСЛЕ ВМ из for_each-vm.tf благодаря depends_on.

# Data source для получения актуального образа Ubuntu 22.04 LTS.
# Используется и в for_each-vm.tf.
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "web" {
  count = 2

  # count.index начинается с 0, поэтому +1 → web-1, web-2 (не web-0, web-1)
  name = "web-${count.index + 1}"

  resources {
    cores  = 2
    memory = 2
  }

boot_disk {
  initialize_params {
    image_id = data.yandex_compute_image.ubuntu.id
    size     = 10
    type     = "network-ssd"   # ← добавить
  }
}

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    # Группа безопасности из задания 1.
    # В security.tf ресурс объявлен как:
    #   resource "yandex_vpc_security_group" "example" { name = "example_dynamic" ... }
    # Поэтому ссылаемся на локальное имя "example", а не на отображаемое "example_dynamic".
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  # Требование п.3: web-ВМ создаются после БД-ВМ.
  # depends_on гарантирует, что все инстансы yandex_compute_instance.db
  # будут созданы до начала создания web-ВМ.
  depends_on = [yandex_compute_instance.db]
}