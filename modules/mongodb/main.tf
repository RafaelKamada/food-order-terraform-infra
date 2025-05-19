resource "aws_security_group" "mongodb" {
  name        = "SG-${var.project_name}-mongodb"
  description = "Security Group for MongoDB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }

  depends_on = [
    aws_security_group.mongodb
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
            value = var.database_name
          }

          command = ["mongod"]
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

output "mongodb_service_ip" {
  value = kubernetes_service.mongodb.spec[0].cluster_ip
}

output "mongodb_namespace" {
  value = kubernetes_namespace.mongodb.metadata[0].name
}
