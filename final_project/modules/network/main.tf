resource "google_compute_network" "vpc" {
  name = "app-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "app-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc.self_link
  region        = var.region
}

resource "google_compute_global_address" "lb_ip" {
  name   = "load-balancer-ip"
}

resource "google_compute_firewall" "lb_access" {
  name    = "allow-lb-access"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = var.allowed_ips
  target_tags   = ["app-server"]
}

resource "google_compute_health_check" "app_health" {
  name = "app-health-check-ab"
  check_interval_sec = 5
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 80
    request_path = "/"
  }
}

resource "google_compute_backend_service" "app_backend" {
  name = "app-backend"
  protocol = "HTTP"
  port_name = "http"
  timeout_sec = 30

  backend {
    group = var.instance_group
  }

  health_checks = [google_compute_health_check.app_health.self_link]
}

resource "google_compute_url_map" "app_url_map" {
  name = "app-url-map"
  default_service = google_compute_backend_service.app_backend.self_link
}

resource "google_compute_target_http_proxy" "app_proxy" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.app_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "app_forwarding" {
  name       = "app-forwarding-rule"
  target     = google_compute_target_http_proxy.app_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.self_link
}