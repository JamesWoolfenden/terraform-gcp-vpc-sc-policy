resource "google_access_context_manager_access_policy" "default" {
  parent = "organizations/${var.org_id}"
  title  = var.policy_title
  lifecycle {
    prevent_destroy = true
  }
}
