resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name = "GitHub"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref" = "assertion.ref"
  }

  attribute_condition = "assertion.repository == 'O01o/mach_mlops_app'"
}
