output "mlforge_uri" {
  value       = google_cloud_run_v2_service.mlforge.uri
  description = "mlforge Tracking Server URI"
}