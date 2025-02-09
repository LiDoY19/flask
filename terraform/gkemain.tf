provider "google" {
  credentials = var.gcp_credentials_file
  project     = "polar-ray-449912-k6"
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
    max_node_count = 2
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

  provider "kubernetes" {
    host = google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    token = data.google_client_config.default.access_token
  }

  data "google_client_config" "default" {}

  resource "kubernetes_namespace" "flask_app" {
    metadata {
      name = "flask-app-namespace"
    }
  }

  resource "kubernetes_deployment" "flask_app" {
    metadata {
      name = "flask-app-deployment"
      namespace = kubernetes_namespace.flask_app.metadata[0].name
      labels = {app = "flask-app}
    }
  }

  spec{
    replecas = 2
    selector { match_labels = {app = "flask-app"}}
    template {
      matadata { labels = { app = "flask-app"}}
      spec{
        container{
          name = "flask-app-container"
          image = "gif_app_project"
          ports {container_port = 5000}
        }
      }
    }
  }

  resourse "kubernetes_service" "flask_app" {
    metadata{
      name = "flask-app-service"
      namespace = kubernetes_namespace.flask_app.metadata{0}.name
    }
    spec{
      selector = { app = "flask-app" }
      port{
        port = 80 
        target_port = 5000
      }
      type = "LoadBalancer" 
    }
  }