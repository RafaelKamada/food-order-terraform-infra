resource "kubernetes_config_map" "db_config" {
  metadata {
    name = "db-config"
  }
  data = {
    "DB_CONNECTION_STRING" = "Host=food-order-db.cpqtqlmpyljc.us-east-1.rds.amazonaws.com;Port=5432;Database=foodorderdb;Username=postgres;***"
  }
  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node
  ]
}
 
resource "kubernetes_deployment" "api" {
  metadata {
    name = "api-deployment"
    labels = {
      app = "api-cardapio"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "api-cardapio"
      }
    }

    template {
      metadata {
        labels = {
          app = "api-cardapio"
        }
      }

      spec {
        container {
          name  = "api-cardapio"
          image = "japamanoel/foodorder_cardapio:latest"

          port {
            container_port = 9000
          }

          env {
            name  = "ASPNETCORE_URLS"
            value = "http://0.0.0.0:9000"
          }

          env {
            name = "ConnectionStrings__DefaultConnection"
            value_from {
              config_map_key_ref {
                name = "db-config"
                key  = "DB_CONNECTION_STRING"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_config_map.db_config
  ]
}

resource "kubernetes_service" "api" {
  metadata {
    name = "api-svc"
    labels = {
      app = "api-cardapio"
    }
  }

  spec {
    selector = {
      app = "api-cardapio"
    }

    port {
      port        = 80
      target_port = "9000"
      node_port   = 30080
    }

    type = "LoadBalancer"
  }
  depends_on = [
    kubernetes_deployment.api
  ]
}
