resource "google_compute_network" "vpc" {
  name = "mlops-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name = "mlops-subnet"
  ip_cidr_range = "10.0.0.0/16"
  network = google_compute_network.vpc.id
}
