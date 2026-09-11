terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "storage" {
  source                  = "./storage"
  storage_bucket_location = var.region
}

module "network" {
  source = "./network"
}

module "compute" {
  source                        = "./compute"
  project_id                    = var.project_id
  image_root_path               = "${var.region}-docker.pkg.dev/${var.project_id}"
  cloud_run_location            = var.region
  bucket_name                   = module.storage.bucket
  swagger_ui_service_account_email = google_service_account.cloud_run_swagger_ui_sa.email
  train_api_service_account_email   = google_service_account.cloud_run_train_api_sa.email
  eval_api_service_account_email    = google_service_account.cloud_run_eval_api_sa.email
  mlforge_service_account_email = google_service_account.cloud_run_mlforge_sa.email
  depends_on = [
    module.network,
    module.storage,
    google_project_iam_member.cloud_run_mlforge_secret_accessor,
  ]
}

module "pipeline" {
  source             = "./pipeline"
  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  vpc_id             = module.network.vpc_id
  subnet_id          = module.network.subnet_id
  mlforge_uri        = module.compute.mlforge_uri
  sa_email_workflows = google_service_account.workflows_sa.email
  train_batch_image  = "${var.region}-docker.pkg.dev/${var.project_id}/mlops-train-batch/train-batch:latest"
  train_batch_service_account = google_service_account.compute_train_batch_sa.email

  depends_on = [module.compute]
}
