resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node
  ]
}
 
resource "kubernetes_deployment" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
    labels = {
      app = "mongodb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:6.0.10"

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "250m"
            }
          }

          env {
            name  = "MONGO_INITDB_DATABASE"
            value = "FoodOrder_Cardapio"
          }

          command = ["mongod"]
          args = ["--bind_ip_all"]

          port {
            container_port = 27017
          }

          liveness_probe {
            exec {
              command = ["mongosh", "--eval", "db.adminCommand('ping')"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = ["mongosh", "--eval", "db.adminCommand('ping')"]
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }

        node_selector = {
          "beta.kubernetes.io/arch" = "amd64"
        }
      }
    }
  }

  depends_on = [
    aws_eks_node_group.eks-node,
    kubernetes_namespace.mongodb
  ]
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
    }

    type = "LoadBalancer"
  }

  depends_on = [
    aws_eks_node_group.eks-node,
    kubernetes_deployment.mongodb
  ]
}
