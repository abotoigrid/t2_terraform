resource "google_secret_manager_secret" "secret" {
  secret_id = "my-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = "my-secret-value"
}