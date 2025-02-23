# resource "kubernetes_deployment" "mysql" {
#   depends_on = [
#     kubernetes_namespace.flask_app,
#     kubernetes_config_map.mysql_initdb
#   ]
#   metadata {
#     name      = "mysql-deployment"
#     namespace = kubernetes_namespace.flask_app.metadata[0].name
#     labels    = { app = "mysql" }
#   }
#   spec {
#     replicas = 1
#     selector {
#       match_labels = { app = "mysql" }
#     }
#     template {
#       metadata {
#         labels = { app = "mysql" }
#       }
#       spec {
#         container {
#           name  = "mysql"
#           image = "mysql:8.0"

#           # Environment variables required by the MySQL image.
#           env {
#             name  = "MYSQL_ROOT_PASSWORD"
#             value = "password"  // In production, store this securely!
#           }
#           env {
#             name  = "MYSQL_DATABASE"
#             value = "mydatabase"
#           }

#           port {
#             container_port = 3306
#           }

#           # Mount the init script from the ConfigMap.
#           volume_mount {
#             name       = "initdb"
#             mount_path = "/docker-entrypoint-initdb.d"
#           }
#         }

#         # Define the volume to use the ConfigMap.
#         volume {
#           name = "initdb"
#           config_map {
#             name = kubernetes_config_map.mysql_initdb.metadata[0].name
#             items {
#               key  = "init.sql"
#               path = "init.sql"
#             }
#           }
#         }
#       }
#     }
#   }
# }
