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

module "security" {
  source = "./security"
  project_id = var.project_id
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
  swagger_ui_service_account_email = module.security.swagger_ui_service_account_email
  train_api_service_account_email   = module.security.train_api_service_account_email
  eval_api_service_account_email    = module.security.eval_api_service_account_email
  mlforge_service_account_email = module.security.mlforge_service_account_email
  depends_on = [
    module.security,
    module.network,
    module.storage,
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
  sa_email_workflows = module.security.workflows_sa_email
  train_batch_image  = "${var.region}-docker.pkg.dev/${var.project_id}/mlops-train-batch/train-batch:latest"
  train_batch_service_account = module.security.compute_train_batch_sa_email

  depends_on = [module.compute]
}
