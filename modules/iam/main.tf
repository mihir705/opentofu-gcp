resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = coalesce(var.display_name, var.account_id)
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
