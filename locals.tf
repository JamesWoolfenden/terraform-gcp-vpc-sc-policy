locals {
  # Access levels attached to each perimeter: its IP level and/or identities level, when defined.
  perimeter_access_levels = {
    for name, _ in var.perimeters : name => compact([
      try(google_access_context_manager_access_level.ip[name].name, ""),
      try(google_access_context_manager_access_level.identities[name].name, ""),
    ])
  }

  # A perimeter is configured through exactly one of spec (dry run) or status (enforced).
  perimeter_spec_blocks   = { for name, p in var.perimeters : name => p.dry_run ? [""] : [] }
  perimeter_status_blocks = { for name, p in var.perimeters : name => p.dry_run ? [] : [""] }
}
