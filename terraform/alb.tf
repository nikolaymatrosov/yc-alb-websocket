resource "yandex_alb_http_router" "ws-router" {
  name   = "ws-http-router"
}


resource "yandex_alb_backend_group" "ws-backend-group" {
  name = "ws-backend-group"

  http_backend {
    name             = "ws-http-backend"
    weight           = 1
    port             = 8080
    target_group_ids = [yandex_compute_instance_group.ws-ig.application_load_balancer.0.target_group_id]
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      healthcheck_port = 8080
      http_healthcheck {
        path = "/"
      }
    }
  }
}


resource "yandex_alb_virtual_host" "ws-virtual-host" {
  name           = "ws-virtual-host"
  http_router_id = yandex_alb_http_router.ws-router.id
  route {
    name = "socketio"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.ws-backend-group.id
        timeout          = "3s"
        upgrade_types    = ["websocket"]
      }
    }
  }
}

resource "yandex_alb_load_balancer" "ws-balancer" {
  name = "ws-alb"

  network_id = yandex_vpc_network.ws.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.ws-subnet-a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.ws-subnet-b.id
    }
    location {
      zone_id   = "ru-central1-c"
      subnet_id = yandex_vpc_subnet.ws-subnet-c.id
    }
  }

  listener {
    name = "socket-io"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [8080]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.ws-router.id
      }
    }
  }
}
