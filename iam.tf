# ----------------------------------------------------------
# Service Accounts
# ----------------------------------------------------------

resource "google_service_account" "cloud_run_mlforge_sa" {
  account_id = "cloud-run-mlforge-sa"
  display_name = "Cloud Run MLForge Service Account"
}

resource "google_service_account" "cloud_run_train_api_sa" {
  account_id = "cloud-run-train-api-sa"
  display_name = "Cloud Run Train API Service Account"
}

resource "google_service_account" "compute_train_batch_sa" {
  account_id = "compute-train-batch-sa"
  display_name = "Compute Train Batch Service Account"
}

resource "google_service_account" "workflows_sa" {
  account_id = "workflows-sa"
  display_name = "Workflows Execution Service Account"
}

resource "google_service_account" "github_actions_sa" {
  account_id = "github-actions-sa"
  display_name = "Workflows Execution Service Account"
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

resource "google_project_iam_member" "cloud_run_train_api_workflows_invoker" {
  project = data.google_project.project.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_train_api_sa.email}"
}

resource "google_project_iam_member" "compute_train_batch_storage_admin" {
  project = data.google_project.project.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.compute_train_batch_sa.email}"
}

resource "google_project_iam_member" "compute_train_batch_cloud_run_invoker" {
  project = data.google_project.project.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.compute_train_batch_sa.email}"
}

resource "google_project_iam_member" "workflows_compute_admin" {
  project = data.google_project.project.project_id
  role = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.workflows_sa.email}"
}

resource "google_project_iam_member" "workflows_pubsub_admin" {
  project = data.google_project.project.project_id
  role = "roles/pubsub.admin"
  member = "serviceAccount:${google_service_account.workflows_sa.email}"
}

resource "google_project_iam_member" "ar_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_project_iam_member" "sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}
