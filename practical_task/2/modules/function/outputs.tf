output "function_name" {
  value = google_cloudfunctions_function.function.name
}

output "service_account_email" {
  value = var.service_account_email
}

# output "function_full_name" {
#   value = google_cloudfunctions_function.function.id  # Full resource ID
# }