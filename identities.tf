resource "azuread_application" "app" {
  display_name = var.spn_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "app_password" {
  application_object_id = azuread_application.app.object_id
}

resource "azuread_service_principal" "spn" {
  application_id = azuread_application.app.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "kubeadmin" {
  principal_id         = data.azuread_client_config.current.object_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = azurerm_kubernetes_cluster.akscluster.id
}

resource "azurerm_role_assignment" "kubeadminspn" {
  principal_id                     = azuread_service_principal.spn.object_id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                            = azurerm_kubernetes_cluster.akscluster.id
  skip_service_principal_aad_check = true
}