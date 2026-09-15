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
  train_batch_image  = "${var.region}-docker.pkg.dev/${var.project_id}/mlops-train-batch/train-batch:latest"

  depends_on = [module.compute]
}
