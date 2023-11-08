# Описание облака
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Описание доступа и токена
provider "yandex" {
  token     = "Сюда Токен"
  cloud_id  = "Сюда Облако"
  folder_id = "Сюда папку в облаке"
}