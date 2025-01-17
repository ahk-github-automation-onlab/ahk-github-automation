terraform {
  backend "azurerm" {
    resource_group_name  = "tfstates"
    storage_account_name = "ahktfstate"
    container_name       = "tfstate"
    key                  = "tfstate.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
    }
    github = {
      source  = "integrations/github"
      version = "=5.19.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "github" {
  organization = "ahk-github-automation-onlab"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "ahk-github-onlab"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  name                     = "ahkgithubstorageonlab"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "ahk-github-app-service-plan-onlab"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app" {
  name                = "ahk-github-function-app-onlab"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name


  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id



  site_config {}
}

data "github_repository" "repository" {
  full_name = "ahk-github-automation-onlab/ahk-github-automation"
}

resource "github_app_installation_repository" "github_app" {
  repository      = data.github_repository.repository.name
  installation_id = random_string.random_id.result
}
