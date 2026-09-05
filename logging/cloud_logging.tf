resource "google_logging_project_bucket_config" "logs" {
  project    = var.project_id
  location   = var.location
  bucket_id  = "ml-system-logs"
  retention_days = 30
}

resource "google_logging_project_sink" "sink" {
  name        = "ml-process-sink"
  destination = "logging.googleapis.com/${google_logging_project_bucket_config.logs.id}"
  filter      = "resource.type=\"cloud_run_revision\" AND textPayload:\"ML\""
}