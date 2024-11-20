output "k3s_instance_ip" {
  value = google_compute_instance.k3s_instance.network_interface[0].access_config[0].nat_ip
}
