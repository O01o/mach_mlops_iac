terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

locals {
  services = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "iap.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "workflows.googleapis.com",
    "pubsub.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "iap.googleapis.com",
    "servicenetworking.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.services)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "security" {
  source            = "./security"
  project_id        = var.project_id
  github_owner      = var.github_owner
  github_repository = var.github_repository

  depends_on = [google_project_service.apis]
}

module "storage" {
  source                  = "./storage"
  storage_bucket_location = var.region

  depends_on = [google_project_service.apis]
}

module "network" {
  source = "./network"

  depends_on = [google_project_service.apis]
}

module "compute" {
  source             = "./compute"
  project_id         = var.project_id
  image_root_path    = "${var.region}-docker.pkg.dev/${var.project_id}"
  cloud_run_location = var.region
  bucket_name        = module.storage.bucket
  depends_on = [
    module.security,
    module.network,
    module.storage,
  ]
}

module "pipeline" {
  source            = "./pipeline"
  project_id        = var.project_id
  region            = var.region
  zone              = var.zone
  vpc_id            = module.network.vpc_id
  subnet_id         = module.network.subnet_id
  mlforge_uri       = module.compute.mlforge_uri
  train_batch_image = "${var.region}-docker.pkg.dev/${var.project_id}/mlops-train-batch/train-batch:latest"

  depends_on = [module.compute, google_project_service.apis]
}
