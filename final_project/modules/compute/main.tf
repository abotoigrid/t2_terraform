locals {
  startup_script = <<EOF
#!/bin/bash
apt-get update
apt-get install -y apache2
echo "<h1>Server: $(hostname)</h1>" > /var/www/html/index.html
systemctl restart apache2
EOF
}

resource "google_compute_instance_template" "app_template" {
  name_prefix = "app-template-"
  machine_type = "e2-medium"

  tags = ["app-server"]

  disk {
    source_image = "debian-cloud/debian-11"
    boot = true
    auto_delete = true
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config {}
  }

  metadata_startup_script = local.startup_script

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "app_group" {
  name = "app-group"
  base_instance_name = "app-server"
  zone = "${var.region}-a"
  target_size = 3

  version {
    instance_template = google_compute_instance_template.app_template.self_link
  }
}

