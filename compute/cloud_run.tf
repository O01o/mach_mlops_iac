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
    volumes {
      name = "DB_CA_CERT"

      secret {
        secret = "DB_CA_CERT"
        
        items {
          version = "latest"
          path = "isrgrootx1.pem"
        }
      }
    }

    containers {
      image = "ayatomatsui/mlforge:latest"

      volume_mounts {
        name = "DB_CA_CERT"
        mount_path = "/cert"
      }

      env {
        name  = "DB_HOST"
        
        value_source {
          secret_key_ref {
            secret = "DB_HOST"
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_PORT"
        
        value_source {
          secret_key_ref {
            secret = "DB_PORT"
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_USER"
        
        value_source {
          secret_key_ref {
            secret = "DB_USER"
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_PASSWORD"
        
        value_source {
          secret_key_ref {
            secret = "DB_PASSWORD"
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_NAME"
        
        value_source {
          secret_key_ref {
            secret = "DB_NAME"
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_TLS"
        
        value_source {
          secret_key_ref {
            secret = "DB_TLS"
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_CA_CERT"
        value = "/cert/isrgrootx1.pem"
      }


      ports {
        container_port = 8080
      }
    }
  }
}