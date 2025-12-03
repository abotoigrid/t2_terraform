resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-data-bucket"
  location = var.region
  uniform_bucket_level_access = true
}