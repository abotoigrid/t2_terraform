output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}

output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}