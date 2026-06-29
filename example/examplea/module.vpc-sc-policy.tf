# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "vpc_sc_policy" {
  source       = "../../"
  org_id       = var.org_id
  policy_title = var.policy_title
  perimeters   = var.perimeters
}
