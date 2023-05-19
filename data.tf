# Pulling data from subscription and client configuration
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

data "azuread_client_config" "current" {
}

# retrieve the versions of Kubernetes supported by AKS
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

data "azuread_service_principal" "aks_aad_server" {
  display_name = "Azure Kubernetes Service AAD Server"
}

data "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.log_analytics_name
  resource_group_name = var.rg_log_analytics
}

data "azurerm_subnet" "subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_vnet
}