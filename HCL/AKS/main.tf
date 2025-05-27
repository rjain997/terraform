terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "blob_for_terraform"
    storage_account_name = "maronaamrj"
    container_name       = "tfstate"
    key                 = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}  # This is required by the azurerm provider
  subscription_id = "c709ea7b-58cc-4a06-a97e-7f87976e33b8"
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "samurai"
  location = "West Europe"
}


resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}