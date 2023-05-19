resource "kubernetes_namespace_v1" "ns" {
  metadata {
    name = var.namespace_name
  }
}