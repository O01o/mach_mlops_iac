output "swagger_ui_service_account_email" {
  value = google_service_account.cloud_run_swagger_ui_sa.email
}

output "train_api_service_account_email" {
  value = google_service_account.cloud_run_train_api_sa.email
}

output "eval_api_service_account_email" {
  value = google_service_account.cloud_run_eval_api_sa.email
}

output "mlforge_service_account_email" {
  value = google_service_account.cloud_run_mlforge_sa.email
}

output "compute_train_batch_sa_email" {
  value = google_service_account.compute_train_batch_sa.email
}

output "workflows_sa_email" {
  value = google_service_account.workflows_sa.email
}