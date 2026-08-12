variable "org_id" {
  type        = string
  description = "GCP organization ID."

  validation {
    condition     = can(regex("^[0-9]+$", var.org_id))
    error_message = "org_id must be a numeric organization ID."
  }
}

variable "policy_title" {
  type        = string
  description = "Display title for the access policy."

  validation {
    condition     = length(trimspace(var.policy_title)) > 0
    error_message = "policy_title must not be empty."
  }
}

variable "perimeters" {
  type = map(object({
    project_numbers     = list(string)
    restricted_services = list(string)
    allowed_ip_ranges   = optional(list(string), [])
    allowed_identities  = optional(list(string), [])
    dry_run             = optional(bool, false)
  }))
  description = "Perimeter definitions."

  validation {
    condition     = length(var.perimeters) > 0
    error_message = "perimeters must not be empty."
  }
  validation {
    condition = alltrue([
      for k, v in var.perimeters : length(v.project_numbers) > 0
    ])
    error_message = "Each perimeter must specify at least one project_numbers entry."
  }
  validation {
    condition = alltrue([
      for k, v in var.perimeters : length(v.restricted_services) > 0
    ])
    error_message = "Each perimeter must specify at least one restricted_services entry."
  }
}
