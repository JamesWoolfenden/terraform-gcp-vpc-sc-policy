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
