resource "google_artifact_registry_repository" "preprocessor" {
  repository_id = "mlops-preprocessor"
  format        = "DOCKER"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_artifact_registry_repository" "train_batch" {
  repository_id = "mlops-train-batch"
  format        = "DOCKER"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_artifact_registry_repository" "train_api" {
  repository_id = "mlops-train-api"
  format        = "DOCKER"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_artifact_registry_repository" "eval_api" {
  repository_id = "mlops-eval-api"
  format        = "DOCKER"

  lifecycle {
    prevent_destroy = false
  }
}
