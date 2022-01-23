data "yandex_compute_image" "container-optimized-image" {
  family    = "container-optimized-image"
  folder_id = "standard-images"
}

data "template_file" "cloud_init" {
  template = "${file("cloud-init.tpl.yaml")}"
  vars     = {
    ssh_key = "${file(var.public_key_path)}"
  }
}

resource "yandex_compute_instance_group" "ws-ig" {
  name               = "ig-ws"
  service_account_id = yandex_iam_service_account.ig_sa.id
  folder_id          = var.folder_id

  instance_template {
    platform_id        = "standard-v2"
    resources {
      cores  = 2
      memory = 4

    }
    service_account_id = yandex_iam_service_account.ig_sa.id
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.container-optimized-image.id
        size     = 33
        type     = "network-ssd"
      }
    }
    network_interface {
      subnet_ids = [
        yandex_vpc_subnet.ws-subnet-a.id,
        yandex_vpc_subnet.ws-subnet-b.id,
        yandex_vpc_subnet.ws-subnet-c.id,
      ]
      nat        = true
    }

    metadata = {
      docker-compose     = file("docker-compose.yaml")
      user-data          = "${data.template_file.cloud_init.rendered}"
      serial-port-enable = 1
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }

  application_load_balancer {
    target_group_name = "ws-tg"
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.sabind,
  ]
}

