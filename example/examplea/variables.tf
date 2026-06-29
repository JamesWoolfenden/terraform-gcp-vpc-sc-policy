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
}
