terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "ahk-github"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  name                     = "ahkgithubstoragetf"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "ahk-github-app-service-plan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app" {
    name                      = "ahk-github-function-app"
    location                  = azurerm_resource_group.resource_group.location
    resource_group_name       = azurerm_resource_group.resource_group.name
    
    
    storage_account_name       = azurerm_storage_account.storage.name
    storage_account_access_key = azurerm_storage_account.storage.primary_access_key
    service_plan_id            = azurerm_service_plan.service_plan.id



    site_config {}
}