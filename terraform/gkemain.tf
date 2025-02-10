provider "google" {
  credentials = var.gcp_credentials_file
  project     = "polar-ray-449912-k6"
  region      = "us-central1"
}

data "google_container_cluster" "existing" {
  name     = "flask-app-cluster"
  location = "us-central1"
}

#resource "google_container_node_pool" "primary_nodes" {
#  name       = "primary-node-pool"
#  cluster    = data.google_container_cluster.existing.name
#  location   = data.google_container_cluster.existing.location
#
#  node_count = 1
#
#  autoscaling {
#    min_node_count = 1
#    max_node_count = 2
#  }
#
#  node_config {
#    preemptible  = false
#    machine_type = "e2-medium"
#    disk_size_gb = 20
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/cloud-platform"
#    ]
#  }
#}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

data "google_client_config" "default" {}

resource "kubernetes_namespace" "flask_app" {
  metadata {
    name = "flask-app-namespace"
  }
}

resource "kubernetes_deployment" "flask_app" {
  metadata {
    name      = "flask-app-deployment"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
    labels    = { app = "flask-app" }
  }
  spec {
    replicas = 2
    selector {
      match_labels = { app = "flask-app" }
    }
    template {
      metadata {
        labels = { app = "flask-app" }
      }
      spec {
        container {
          name  = "flask-app-container"
          image = "gif_app_project:latest"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask_app" {
  metadata {
    name      = "flask-app-service"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
  }
  spec {
    selector = { app = "flask-app" }
    port {
      port        = 80
      target_port = 5000
    }
    type = "LoadBalancer"
  }
}
