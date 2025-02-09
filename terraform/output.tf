output "gke_cluster_name" {
  description = "The name of the created GKE cluster"
  value       = google_container_cluster.primary.name
}

output "gke_cluster_endpoint" {
  description = "The endpoint for accessing the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "gke_cluster_master_version" {
  description = "The Kubernetes version running on the GKE cluster"
  value       = google_container_cluster.primary.master_version
}

output "gcp_project_id" {
  description = "The Google Cloud project ID"
  value       = google_container_cluster.primary.project
}

output "gke_node_pool_instance_group" {
  description = "Instance group URLs for the default node pool"
  value       = google_container_node_pool.primary_nodes.instance_group_urls
}
