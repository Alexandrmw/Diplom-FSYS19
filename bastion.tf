# Бастион хост
resource "yandex_compute_instance" "bastion-host" {

  zone     = "ru-central1-a"
  name     = "bastion"
  hostname = "bastion"

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
    subnet_id = yandex_vpc_subnet.bastion-external-segment.id
    security_group_ids = [yandex_vpc_security_group.external-ssh-sg.id,
    yandex_vpc_security_group.internal-ssh-sg.id]
    nat        = true
    ip_address = "192.168.50.10"
  }

  metadata = {
    user-data = "${file("./meta-bastion.yaml")}"
  }

  scheduling_policy {
    preemptible = true
  }

}