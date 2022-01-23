resource "yandex_vpc_network" "ws" {
  name = "ws"
}


resource "yandex_vpc_subnet" "ws-subnet-a" {
  name           = "ws-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.ws.id
  v4_cidr_blocks = ["10.240.1.0/24"]
}

resource "yandex_vpc_subnet" "ws-subnet-b" {
  name           = "ws-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.ws.id
  v4_cidr_blocks = ["10.240.2.0/24"]
}

resource "yandex_vpc_subnet" "ws-subnet-c" {
  name           = "ws-subnet-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.ws.id
  v4_cidr_blocks = ["10.240.3.0/24"]
}
