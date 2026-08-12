resource "google_access_context_manager_service_perimeter" "default" {
  for_each = var.perimeters

  parent                    = "accessPolicies/${google_access_context_manager_access_policy.default.name}"
  name                      = "accessPolicies/${google_access_context_manager_access_policy.default.name}/servicePerimeters/${each.key}"
  title                     = each.key
  perimeter_type            = "PERIMETER_TYPE_REGULAR"
  use_explicit_dry_run_spec = each.value.dry_run

  dynamic "spec" {
    for_each = each.value.dry_run ? [""] : []
    content {
      resources           = each.value.project_numbers
      restricted_services = each.value.restricted_services
      access_levels = concat(
        contains(keys(google_access_context_manager_access_level.ip), each.key) ? [google_access_context_manager_access_level.ip[each.key].name] : [],
        contains(keys(google_access_context_manager_access_level.identities), each.key) ? [google_access_context_manager_access_level.identities[each.key].name] : [],
      )
    }
  }

  dynamic "status" {
    for_each = each.value.dry_run ? [] : [""]
    content {
      resources           = each.value.project_numbers
      restricted_services = each.value.restricted_services
      access_levels = concat(
        contains(keys(google_access_context_manager_access_level.ip), each.key) ? [google_access_context_manager_access_level.ip[each.key].name] : [],
        contains(keys(google_access_context_manager_access_level.identities), each.key) ? [google_access_context_manager_access_level.identities[each.key].name] : [],
      )
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
