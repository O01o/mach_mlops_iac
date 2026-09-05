output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}