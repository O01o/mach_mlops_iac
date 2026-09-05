resource "random_id" "gcs_bucket_suffix" {
  byte_length = 12
}

resource "google_storage_bucket" "bucket" {
  name     = "mlops_bucket_${random_id.gcs_bucket_suffix.hex}"
  location = var.storage_bucket_location
}

resource "google_storage_bucket_object" "datasets" {
  name   = "datasets/"
  content = " "
  bucket = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_object" "experiments" {
  name   = "experiments/"
  content = " "
  bucket = google_storage_bucket.bucket.name
}
