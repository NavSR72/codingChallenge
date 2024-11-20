provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "default" {
  name = "k3s-network"
}

resource "google_compute_firewall" "default" {
  name    = "allow-ssh-http-https"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_compute_instance" "k3s_instance" {
  name         = "k3s-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.default.name
    access_config {}
  }

  metadata_startup_script = file("install_k3s.sh")
}

output "instance_ip" {
  value = google_compute_instance.k3s_instance.network_interface[0].access_config[0].nat_ip
}

