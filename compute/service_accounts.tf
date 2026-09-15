# ----------------------------------------------------------
# Service Accounts
# ----------------------------------------------------------

resource "google_service_account" "cloud_run_mlforge_sa" {
  account_id   = "cloud-run-mlforge-sa"
  display_name = "Cloud Run MLForge Service Account"
}
  
resource "google_service_account" "cloud_run_swagger_ui_sa" {
  account_id   = "cloud-run-swagger-ui-sa"
  display_name = "Cloud Run Swagger UI Service Account"
}

resource "google_service_account" "cloud_run_train_api_sa" {
  account_id   = "cloud-run-train-api-sa"
  display_name = "Cloud Run Train API Service Account"
}

resource "google_service_account" "cloud_run_eval_api_sa" {
  account_id   = "cloud-run-eval-api-sa"
  display_name = "Cloud Run Evaluate API Service Account"
}


# ----------------------------------------------------------
# Service Account Roles
# ----------------------------------------------------------

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_iam_member" "cloud_run_mlforge_secret_accessor" {
  project = data.google_project.project.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_mlforge_sa.email}"
}

resource "google_project_iam_member" "cloud_run_swagger_ui_call_train_api" {
  project = data.google_project.project.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_swagger_ui_sa.email}"
}

resource "google_project_iam_member" "cloud_run_train_api_workflows_invoker" {
  project = data.google_project.project.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_train_api_sa.email}"
}
