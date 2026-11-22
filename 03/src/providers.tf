terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.12.0"
}

provider "yandex" {
  service_account_key_file = "C:/temp_tf/Yandex_secret_token_KEY/authorized_key.json"
  cloud_id  = "b1gdbfkqt3i6lq5d3ii1"
  folder_id = "b1gdq3qf3b07keqioiig"
  zone      = "ru-central1-a"
}