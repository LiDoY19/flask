provider "google" {
  credentials = file(env.GOOGLE_APPLICATION_CREDENTIALS)  # Use environment variable
  project     = "polar-ray-449912"
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "flask-app-cluster"
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1

  # Enable autoscaling at the cluster level
  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    disk_size_gb = 20
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
