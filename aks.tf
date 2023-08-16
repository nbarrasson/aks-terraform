resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.rg_kube
  dns_prefix          = var.aks_cluster_name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  # Lockdown API server
  api_server_access_profile {
    authorized_ip_ranges = [
      "${data.http.myip.response_body}/32",
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  # CNI networking
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "172.38.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "172.38.0.0/16"
    load_balancer_sku  = "standard"
  }

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_DS3_v2"
    vnet_subnet_id = data.azurerm_subnet.subnet.id
  }

  # Enable AAD RBAC
  azure_active_directory_role_based_access_control {
    managed            = true
    tenant_id          = data.azurerm_subscription.current.tenant_id
    azure_rbac_enabled = true

  }
  # Disable local accounts
  local_account_disabled = true

  # Container Insights
  oms_agent {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id
  }

  # Enable Microsoft Defender for Containers
  microsoft_defender {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id
  }

  # Enable Key Vault Secret Provider
  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  # Enable Azure Policy
  azure_policy_enabled = true

  # Enable KEDA autoscaler
  # workload_autoscaler_profile {
  #   keda_enabled = true
  # }
}

# Create Role Assignment on Azure Container Registry
resource "azurerm_role_assignment" "acr_role_assignment" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.akscluster.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}