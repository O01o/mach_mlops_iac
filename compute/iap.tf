data "google_project" "current" {
  project_id = var.project_id
}

resource "google_project_service_identity" "iap" {
  provider = google-beta
  service  = "iap.googleapis.com"
}


# ----------------------------------------------------------
# IAP Invokers
# ----------------------------------------------------------

resource "google_cloud_run_v2_service_iam_member" "iap_invoker_swagger_ui" {
  location = var.cloud_run_location
  name     = "swagger-ui"

  role = "roles/run.invoker"
  member = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-iap.iam.gserviceaccount.com"
}

resource "google_cloud_run_v2_service_iam_member" "iap_invoker_mlforge" {
  location = var.cloud_run_location
  name     = "mlforge"

  role = "roles/run.invoker"
  member = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-iap.iam.gserviceaccount.com"
}


# ----------------------------------------------------------
# IAP IAM Bindings
# ----------------------------------------------------------

resource "google_iap_web_cloud_run_service_iam_binding" "swagger_ui" {
  location               = var.cloud_run_location
  cloud_run_service_name = "swagger-ui"

  role = "roles/iap.httpsResourceAccessor"

  members = [
    "group:researchers@okinoshimanomizugami.com",
    # "user:admin@example.com",
  ]

  depends_on = [
    google_cloud_run_v2_service_iam_member.iap_invoker_swagger_ui
  ]
}

resource "google_iap_web_cloud_run_service_iam_binding" "mlforge" {
  location               = var.cloud_run_location
  cloud_run_service_name = "mlforge"

  role = "roles/iap.httpsResourceAccessor"

  members = [
    "group:researchers@okinoshimanomizugami.com",
    # "user:admin@example.com",
  ]

  depends_on = [
    google_cloud_run_v2_service_iam_member.iap_invoker_mlforge
  ]
}
