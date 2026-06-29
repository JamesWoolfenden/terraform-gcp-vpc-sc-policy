# holden:ignore:HLD_GCP_059
provider "google" {
  default_labels = {
    created_by = "terraform"
    module     = "terraform-gcp-vpc-sc-policy"
  }
}
