output "access_policy_name" {
  description = "The access policy name — pass to terraform-gcp-vpc-sc-perimeter for team-level additions."
  value       = google_access_context_manager_access_policy.default.name
}

output "perimeters" {
  description = "Map of perimeter name to perimeter resource."
  value       = google_access_context_manager_service_perimeter.default
}
