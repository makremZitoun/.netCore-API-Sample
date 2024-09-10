provider "azurerm" {
  features {}
  version = "~>3.0"
  #subscription_id = ${{ secrets.AZURE_SUBSCRIPTION_ID }}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = "East US"
}
resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id


  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "development"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

