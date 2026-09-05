terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~> 5.0"
        }
    }
}

provider "google" {
    project = var.project_id
    region = var.region
    zone = var.zone
}

module "storage" {
  source = "./storage"
  storage_bucket_location = var.region
}

module "network" {
    source = "./network"
}

module "compute" {
  source = "./compute"
  project_id = var.project_id
  image_root_path = "${var.region}-docker.pkg.dev/${var.project_id}"
  cloud_run_location = var.region
  db_user = var.db_user
  db_ip = var.db_ip
  db_name = var.db_name
  db_password = var.db_password
  bucket_name = module.storage.bucket

  depends_on = [module.network, module.storage]
}

module "pipeline" {
  source = "./pipeline"
  project_id = var.project_id
  region = var.region
  zone = var.zone
  vpc_id = module.network.vpc_id
  subnet_id = module.network.subnet_id
  mlforge_uri = module.compute.mlforge_uri
  sa_email_workflows = google_service_account.workflows_sa.email

  depends_on = [module.compute]
}
