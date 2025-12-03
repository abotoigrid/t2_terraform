resource "google_storage_bucket" "source_bucket" {
  name     = "${var.project_id}-function-source"
  location = var.region
  uniform_bucket_level_access = true
}

data "archive_file" "function_code" {
  type        = "zip"
  source_dir  = "${path.module}/../../function_code"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "source_zip" {
  name   = "function-${data.archive_file.function_code.output_md5}.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = data.archive_file.function_code.output_path
}

resource "google_cloudfunctions_function" "function" {
  name                  = "my-function"
  runtime               = "python39"
  entry_point           = "hello_http"
  source_archive_bucket = google_storage_bucket.source_bucket.name
  source_archive_object = google_storage_bucket_object.source_zip.name
  trigger_http          = true
  ingress_settings = "ALLOW_INTERNAL_AND_GCLB"
  vpc_connector         = var.vpc_connector
  vpc_connector_egress_settings = "ALL_TRAFFIC"
  service_account_email = var.service_account_email
  environment_variables = {
    SECRET_ID   = var.secret_id
    BUCKET_NAME = var.bucket_name
    GOOGLE_CLOUD_PROJECT = var.project_id
  }
}

#IAM policy to allow public invocation
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"  # Public access for testing
  #member = "allAuthenticatedUsers"
}

# Testing the load balancer ip
# curl -m 70 -X POST http://34.149.129.186:80 \
# -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
# -H "Content-Type: application/json" \
# -d '{}'