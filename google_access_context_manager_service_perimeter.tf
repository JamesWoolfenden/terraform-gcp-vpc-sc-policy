resource "google_access_context_manager_service_perimeter" "default" {
  for_each = var.perimeters

  parent                    = "accessPolicies/${google_access_context_manager_access_policy.default.name}"
  name                      = "accessPolicies/${google_access_context_manager_access_policy.default.name}/servicePerimeters/${each.key}"
  title                     = each.key
  perimeter_type            = "PERIMETER_TYPE_REGULAR"
  use_explicit_dry_run_spec = each.value.dry_run

  dynamic "spec" {
    for_each = local.perimeter_spec_blocks[each.key]
    content {
      resources           = each.value.project_numbers
      restricted_services = each.value.restricted_services
      access_levels       = local.perimeter_access_levels[each.key]
    }
  }

  dynamic "status" {
    for_each = local.perimeter_status_blocks[each.key]
    content {
      resources           = each.value.project_numbers
      restricted_services = each.value.restricted_services
      access_levels       = local.perimeter_access_levels[each.key]
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
