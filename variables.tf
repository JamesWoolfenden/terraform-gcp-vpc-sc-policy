variable "org_id" {
  description = "GCP organization ID (numeric)."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.org_id))
    error_message = "org_id must be a numeric organization ID."
  }
}

variable "policy_title" {
  description = "Display title for the access policy."
  type        = string

  validation {
    condition     = length(trimspace(var.policy_title)) > 0
    error_message = "policy_title must not be empty."
  }
}

variable "perimeters" {
  description = "Perimeters to manage. Each entry controls which projects and services are protected, and who can access them."
  type = map(object({
    project_numbers     = list(string)
    restricted_services = list(string)
    allowed_ip_ranges   = optional(list(string), [])
    allowed_identities  = optional(list(string), [])
    dry_run             = optional(bool, false)
  }))

  validation {
    condition     = length(var.perimeters) > 0
    error_message = "At least one perimeter must be defined."
  }
  validation {
    condition = alltrue([
      for k, v in var.perimeters : alltrue([
        for p in v.project_numbers : can(regex("^projects/", p))
      ])
    ])
    error_message = "Each project_numbers entry must start with 'projects/'."
  }
  validation {
    condition = alltrue([
      for k, v in var.perimeters : alltrue([
        for i in v.allowed_identities : can(regex("^(serviceAccount:|user:|group:)", i))
      ])
    ])
    error_message = "Each allowed_identity must start with 'serviceAccount:', 'user:', or 'group:'."
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
