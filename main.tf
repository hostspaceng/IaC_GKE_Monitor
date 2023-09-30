resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name               = "monitoring"
  location           = "us-central1-a"
  initial_node_count = 3
  network            = "default"
  node_config {
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = "test"
    }
    tags = ["test"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}
