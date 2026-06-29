# holden:ignore:HLD_TF_004
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.30.0"
    }
  }
  required_version = ">= 1.9.0"
}
