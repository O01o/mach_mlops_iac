variable "project_id" {
  type = string
}

variable "image_root_path" {
  type = string
}

variable "cloud_run_location" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "swagger_ui_service_account_email" {
  type = string
}

variable "train_api_service_account_email" {
  type = string
}

variable "eval_api_service_account_email" {
  type = string
}

variable "mlforge_service_account_email" {
  type = string
}
