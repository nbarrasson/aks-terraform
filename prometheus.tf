# SPN and roles propagation can last long so waiting 1 minute before creating Kubernetes assets
resource "time_sleep" "wait_1_minute" {
  depends_on      = [azurerm_role_assignment.kubeadminspn]
  create_duration = "60s"
}

# Creating monitoring namespace
resource "kubernetes_namespace_v1" "ns" {
  metadata {
    name = "monitoring"
  }
  depends_on     = [time_sleep.wait_1_minute]
}

# Deploying Prometheus
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "22.6.2"
  chart      = "prometheus"
  depends_on = [ module.monitoring ]
}