# ----------------------------------------------------------
# Pub/Sub Batch Exclusive Lock Topic and Subscription
# ----------------------------------------------------------

resource "google_pubsub_topic" "exclusive_lock_topic" {
  name = "mlops-exclusive-lock-topic"
}

resource "google_pubsub_topic" "exclusive_lock_dead_letter_topic" {
  name = "mlops-exclusive-lock-dead-letter-topic"
}


resource "google_pubsub_subscription" "exclusive_lock_sub" {
  name  = "exclusive-lock-subscription"
  topic = google_pubsub_topic.exclusive_lock_topic.name

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "864000s" # terminated in 10 days
  }

  retry_policy {
    minimum_backoff = "10s"
  }

  dead_letter_policy {
    dead_letter_topic = google_pubsub_topic.exclusive_lock_dead_letter_topic.id
    max_delivery_attempts = 10
  }

  enable_message_ordering = true
}


# ----------------------------------------------------------
# Pub/Sub Train Topic and Subscription
# ----------------------------------------------------------

resource "google_pubsub_topic" "train_topic" {
  name = "mlops-train-topic"
}

resource "google_pubsub_topic" "train_dead_letter_topic" {
  name = "mlops-train-dead-letter-topic"
}

resource "google_pubsub_subscription" "train_sub" {
  name  = "mlops-train-subscription"
  topic = google_pubsub_topic.train_topic.name

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "864000s" # terminated in 10 days
  }

  retry_policy {
    minimum_backoff = "10s"
  }

  dead_letter_policy {
    dead_letter_topic = google_pubsub_topic.train_dead_letter_topic.id
    max_delivery_attempts = 10
  }

  enable_message_ordering = true
}

