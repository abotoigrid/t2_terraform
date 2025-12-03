resource "google_compute_global_address" "lb_ip" {
  name = "lb-ip"
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "serverless-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_function {
    function = var.function_name
  }
}

resource "google_compute_backend_service" "backend" {
  name     = "backend-service"
  protocol = "HTTP"
  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_http_proxy.proxy.id
  ip_address = google_compute_global_address.lb_ip.address
  port_range = "80"
}
