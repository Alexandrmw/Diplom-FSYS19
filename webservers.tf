# Описание Web серверов

###################
# WEB SERVER  № 1 #
###################

resource "yandex_compute_instance" "webserver-1" {

  zone = "ru-central1-a"
  name = "webserver-1"
  hostname = "webserver-1"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s17cfki4sd4l6oa59"
      size     = 5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion-internal-segment.id
#    security_group_ids = [ yandex_vpc_security_group.internal-ssh-sg.id ]
    security_group_ids = [yandex_vpc_security_group.external-ssh-sg.id, yandex_vpc_security_group.internal-ssh-sg.id]
    nat       = false
#    ip_address = "192.168.50.1"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

##########################################################################################


###################
# WEB SERVER  № 2 #
###################
resource "yandex_compute_instance" "webserver-2" {

  zone = "ru-central1-a"
  name = "webserver-2"
  hostname = "webserver-2"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s17cfki4sd4l6oa59"
      size     = 5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion-internal-segment.id
#    security_group_ids = [ yandex_vpc_security_group.internal-ssh-sg.id ]
    security_group_ids = [yandex_vpc_security_group.external-ssh-sg.id, yandex_vpc_security_group.internal-ssh-sg.id]
    nat       = false
#    ip_address = "192.168.50.2"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

    scheduling_policy {
    preemptible = true
  }
}