# ----------------------------------------------------------
# Service Accounts
# ----------------------------------------------------------

resource "google_service_account" "workflows_sa" {
  account_id   = "workflows-sa"
  display_name = "Workflows Execution Service Account"
}

resource "google_service_account" "compute_train_batch_sa" {
  account_id   = "compute-train-batch-sa"
  display_name = "Compute Train Batch Service Account"
}


# ----------------------------------------------------------
# Service Account Roles
# ----------------------------------------------------------

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_iam_member" "workflows_compute_admin" {
  project = data.google_project.project.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.workflows_sa.email}"
}

resource "google_project_iam_member" "workflows_pubsub_admin" {
  project = data.google_project.project.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${google_service_account.workflows_sa.email}"
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

resource "google_project_iam_member" "compute_train_batch_artifact_registry_reader" {
  project = data.google_project.project.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.compute_train_batch_sa.email}"
}
