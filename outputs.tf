# Bastion-host
# Бастион Внешние/Внутренний адреса

output "bastion-host_nat" {
  value = yandex_compute_instance.bastion-host.network_interface.0.nat_ip_address
}

output "bastion-host" {
  value = yandex_compute_instance.bastion-host.network_interface.0.ip_address
}

# Вэбсервер - 1
output "webserver-1" {
  value = yandex_compute_instance.webserver-1.network_interface.0.ip_address
}

/* output "webserver-1_nat" {
  value = yandex_compute_instance.webserver-1.network_interface.0.nat_ip_address
}*/

# Вэбсервер - 2
output "webserver-2" {
  value = yandex_compute_instance.webserver-2.network_interface.0.ip_address
}

/*output "webserver-2_nat" {
  value = yandex_compute_instance.webserver-2.network_interface.0.nat_ip_address
} */

# Балансировщик
output "load_balancer_pub" {
  value = yandex_alb_load_balancer.app-lb.listener[0].endpoint[0].address[0].external_ipv4_address
}
