resource "google_access_context_manager_access_policy" "default" {
  parent = "organizations/${var.org_id}"
  title  = var.policy_title
}

resource "google_access_context_manager_access_level" "ip" {
  for_each = { for k, v in var.perimeters : k => v if length(v.allowed_ip_ranges) > 0 }
  parent   = "accessPolicies/${google_access_context_manager_access_policy.default.name}"
  name     = "accessPolicies/${google_access_context_manager_access_policy.default.name}/accessLevels/${each.key}_ip"
  title    = "${each.key} — allowed IP ranges"

  basic {
    conditions {
      ip_subnetworks = each.value.allowed_ip_ranges
    }
  }
}

resource "google_access_context_manager_access_level" "identities" {
  for_each = { for k, v in var.perimeters : k => v if length(v.allowed_identities) > 0 }
  parent   = "accessPolicies/${google_access_context_manager_access_policy.default.name}"
  name     = "accessPolicies/${google_access_context_manager_access_policy.default.name}/accessLevels/${each.key}_identities"
  title    = "${each.key} — allowed identities"

  basic {
    conditions {
      members = each.value.allowed_identities
    }
  }
}

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

  depends_on = [
    google_access_context_manager_access_level.ip,
    google_access_context_manager_access_level.identities,
  ]
}
