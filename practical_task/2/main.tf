provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_service_account" "function_sa" {
  account_id   = "function-sa"
  display_name = "Cloud Function Service Account"
}

module "networking" {
  source     = "./modules/networking"
  project_id = var.project_id
  region     = var.region
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
}

module "secrets" {
  source     = "./modules/secrets"
  project_id = var.project_id
}

module "function" {
  source                = "./modules/function"
  project_id            = var.project_id
  region                = var.region
  vpc_connector         = module.networking.vpc_connector_id
  service_account_email = google_service_account.function_sa.email
  secret_id             = module.secrets.secret_id
  bucket_name           = module.storage.bucket_name
}

module "load_balancer" {
  source        = "./modules/load_balancer"
  project_id    = var.project_id
  region        = var.region
  function_name = module.function.function_name
}

resource "google_storage_bucket_iam_member" "function_storage_viewer" {
  bucket = module.storage.bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.function_sa.email}"
}

resource "google_secret_manager_secret_iam_member" "function_secret_accessor" {
  secret_id = module.secrets.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.function_sa.email}"
}