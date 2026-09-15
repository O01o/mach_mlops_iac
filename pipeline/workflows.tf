resource "google_workflows_workflow" "publish_train_params" {
  name = "mlops-publish-train-params"
  service_account = google_service_account.workflows_sa.email
  
  source_contents = templatefile("${path.module}/workflow_publish_params.yaml", {
    project_id = var.project_id
    topic = google_pubsub_topic.train_topic.name
  })
}

resource "google_workflows_workflow" "train_batch" {
  name = "mlops-train-batch"
  service_account = google_service_account.workflows_sa.email
  
  source_contents = templatefile("${path.module}/workflow_train_batch.yaml", {
    project_id = var.project_id
    region = var.region
    zone = var.zone
    vpc_id = var.vpc_id
    subnet_id = var.subnet_id
    mlforge_uri = var.mlforge_uri
    train_batch_image = var.train_batch_image
    train_batch_service_account = google_service_account.compute_train_batch_sa.email
    exclusive_lock_topic = google_pubsub_topic.exclusive_lock_topic.name
    train_topic = google_pubsub_topic.train_topic.name
    exclusive_lock_sub = google_pubsub_subscription.exclusive_lock_sub.name
    train_sub = google_pubsub_subscription.train_sub.name
    exclusive_lock_message = "exclusive_lock"
  })
}
