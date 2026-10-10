data "google_project" "current" {}

resource "google_project_service_identity" "iap" {
  provider = google-beta
  service  = "iap.googleapis.com"
}

locals {
  iap_services = toset([
    "swagger-ui",
    "mlforge",
  ])

  iap_members = [
    "group:researchers@okinoshimanomizugami.com",
  ]
}

resource "google_cloud_run_v2_service_iam_member" "iap_invoker" {
  for_each = local.iap_services

  location = var.cloud_run_location
  name     = each.value

  role   = "roles/run.invoker"
  member = "serviceAccount:${google_project_service_identity.iap.email}"
}

resource "google_iap_web_cloud_run_service_iam_binding" "users" {
  for_each = local.iap_services

  location               = var.cloud_run_location
  cloud_run_service_name = each.value

  role    = "roles/iap.httpsResourceAccessor"
  members = local.iap_members

  depends_on = [
    google_cloud_run_v2_service_iam_member.iap_invoker
  ]
}