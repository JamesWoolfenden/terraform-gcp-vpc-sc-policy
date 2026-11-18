# terraform-gcp-vpc-sc-policy

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-vpc-sc-policy.svg)](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-vpc-sc-policy.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.9.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)

---

Platform and security team module for managing a complete VPC Service Controls deployment across an organisation. Creates the access policy and all perimeters in a single call. Each perimeter gets its own access levels for IP ranges and trusted identities, and can be in enforced or dry-run mode independently. Use `terraform-gcp-vpc-sc-perimeter` for teams that need to add perimeters to this policy without owning the whole thing.

```terraform
module "vpc_sc_policy" {
  source  = "JamesWoolfenden/vpc-sc-policy/gcp"
  version = "0.0.1"

  org_id       = "123456789012"
  policy_title = "Acme Corp VPC Service Controls"

  perimeters = {
    data_platform = {
      project_numbers = ["projects/111111111111"]
      restricted_services = [
        "bigquery.googleapis.com",
        "storage.googleapis.com",
      ]
      allowed_ip_ranges = ["203.0.113.0/24"]
    }

    ml_workbench = {
      project_numbers     = ["projects/333333333333"]
      restricted_services = ["aiplatform.googleapis.com"]
      allowed_identities  = ["serviceAccount:ml-pipeline@my-project.iam.gserviceaccount.com"]
      dry_run             = true
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_access_context_manager_access_level.identities](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_access_level) | resource |
| [google_access_context_manager_access_level.ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_access_level) | resource |
| [google_access_context_manager_access_policy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_access_policy) | resource |
| [google_access_context_manager_service_perimeter.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_service_perimeter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | GCP organization ID (numeric). | `string` | n/a | yes |
| <a name="input_perimeters"></a> [perimeters](#input\_perimeters) | Perimeters to manage. Each entry controls which projects and services are protected, and who can access them. | <pre>map(object({<br/>    project_numbers     = list(string)<br/>    restricted_services = list(string)<br/>    allowed_ip_ranges   = optional(list(string), [])<br/>    allowed_identities  = optional(list(string), [])<br/>    dry_run             = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_policy_title"></a> [policy\_title](#input\_policy\_title) | Display title for the access policy. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_access_policy_name"></a> [access\_policy\_name](#output\_access\_policy\_name) | The access policy name — pass to terraform-gcp-vpc-sc-perimeter for team-level additions. |
| <a name="output_perimeters"></a> [perimeters](#output\_perimeters) | Map of perimeter name to perimeter resource. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "accesscontextmanager.accessLevels.create",
    "accesscontextmanager.accessLevels.delete",
    "accesscontextmanager.accessLevels.get",
    "accesscontextmanager.accessLevels.update",
    "accesscontextmanager.accessPolicies.create",
    "accesscontextmanager.accessPolicies.delete",
    "accesscontextmanager.accessPolicies.get",
    "accesscontextmanager.accessPolicies.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "accesscontextmanager.accessLevels.get",
    "accesscontextmanager.accessPolicies.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Related Projects

- [terraform-gcp-vpc-sc-bootstrap](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-bootstrap) — First-time VPC-SC setup with dry-run perimeter
- [terraform-gcp-vpc-sc-perimeter](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter) — Add perimeters to an existing access policy

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
