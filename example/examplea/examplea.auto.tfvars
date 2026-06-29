org_id       = "123456789012"
policy_title = "Acme Corp VPC Service Controls"

perimeters = {
  data_platform = {
    project_numbers = [
      "projects/111111111111",
      "projects/222222222222",
    ]
    restricted_services = [
      "bigquery.googleapis.com",
      "storage.googleapis.com",
    ]
    allowed_ip_ranges = ["203.0.113.0/24"]
  }

  ml_workbench = {
    project_numbers = [
      "projects/333333333333",
    ]
    restricted_services = [
      "aiplatform.googleapis.com",
      "notebooks.googleapis.com",
    ]
    allowed_ip_ranges  = ["203.0.113.0/24"]
    allowed_identities = ["serviceAccount:ml-pipeline@my-project.iam.gserviceaccount.com"]
    dry_run            = true
  }
}
