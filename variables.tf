# Azure region
variable "location" {
  type = string
}

# name of the AKS resource group
variable "rg_kube" {
  type = string
}

# name of the Log Analytics resource group
variable "rg_log_analytics" {
  type = string
}

# name of the VNET resource group
variable "rg_vnet" {
  type = string
}

# name of the VNET
variable "vnet_name" {
  type = string
}

# name of the AKS subnet
variable "aks_subnet_name" {
  type = string
}

# name of the AKS cluster
variable "aks_cluster_name" {
  type = string
}

# name of the Log Analytics Workspace
variable "log_analytics_name" {
  type = string
}

# name of the SPN for AKS automation
variable "spn_name" {
  type = string
}