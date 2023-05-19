terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.42.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.33.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
}

provider "azuread" {
  tenant_id = data.azurerm_subscription.current.tenant_id
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.akscluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.cluster_ca_certificate)
  # using kubelogin to get an AAD token for the cluster
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      data.azuread_service_principal.aks_aad_server.application_id, # The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
      "--client-id",
      azuread_service_principal.spn.application_id, # SPN App Id created via terraform
      "--client-secret",
      azuread_application_password.app_password.value,
      "--tenant-id",
      data.azurerm_subscription.current.tenant_id, # AAD Tenant Id
      "--login",
      "spn"
    ]
  }
}