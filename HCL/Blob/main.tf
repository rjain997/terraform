provider "azurerm" {
  features {}
  subscription_id = "c709ea7b-58cc-4a06-a97e-7f87976e33b8"
}

resource "azurerm_resource_group" "backend_rg" {
  name     = "blob_for_terraform"
  location = "West Europe"
}

resource "azurerm_storage_account" "backend_sa" {
  name                     = "maronaamrj"
  resource_group_name      = azurerm_resource_group.backend_rg.name
  location                 = azurerm_resource_group.backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.backend_sa.name
  container_access_type = "private"
}