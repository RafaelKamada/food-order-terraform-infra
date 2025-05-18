resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }

  depends_on = [
    aws_eks_node_group.eks-node
  ]
}

# Primeiro criamos o deployment sem volume
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
            limits = {
              memory = "1Gi"
              cpu    = "500m"
            }
          }

          env {
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = "dev_user"
          }

          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = var.mongodb_admin_password
          }

          port {
            container_port = 27017
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

# Agora criamos o PVC, que será provisionado automaticamente
resource "kubernetes_persistent_volume_claim" "mongodb" {
  metadata {
    name      = "mongodb-pvc"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "gp2"

    resources {
      requests = {
        storage = "20Gi"
      }
    }

    selector {
      match_labels = {
        app = "mongodb"
      }
    }
  }

  depends_on = [
    aws_eks_node_group.eks-node,
    kubernetes_namespace.mongodb,
    kubernetes_deployment.mongodb
  ]
}

# Agora atualizamos o deployment para usar o volume
resource "kubernetes_deployment" "mongodb_update" {
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
            limits = {
              memory = "1Gi"
              cpu    = "500m"
            }
          }

          volume_mount {
            mount_path = "/data/db"
            name       = "mongodb-pvc"
          }

          env {
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = "dev_user"
          }

          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = var.mongodb_admin_password
          }

          port {
            container_port = 27017
          }
        }

        volume {
          name = "mongodb-pvc"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mongodb.metadata[0].name
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
    kubernetes_persistent_volume_claim.mongodb
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
    kubernetes_deployment.mongodb_update
  ]
}
