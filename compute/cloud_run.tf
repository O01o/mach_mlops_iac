resource "google_cloud_run_v2_service" "train_api" {
  name     = "train-api"
  location = var.cloud_run_location

  template {
    containers {
      # image = "${var.image_root_path}/${var.repository_id_train_api}/train-api:latest"
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}

resource "google_cloud_run_v2_service" "eval_api" {
  name     = "eval-api"
  location = var.cloud_run_location

  template {
    containers {
      # image = "${var.image_root_path}/${var.repository_id_eval_api}/eval-api:latest"
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}

resource "google_cloud_run_v2_service" "mlforge" {
  name = "mlforge"
  location = var.cloud_run_location

  template {
    containers {
      # us-docker.pkg.dev/mlforge
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      env {
        name  = "BACKEND_STORE_URI"
        value = ""
      }

      env {
        name  = "MLFORGE_SKIP_DB_UPGRADE"
        value = "true"
      }

      ports {
        container_port = 8080
      }
    }
  }
}