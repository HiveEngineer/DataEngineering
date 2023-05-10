terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}


provider "azurerm" {
  subscription_id = "df6c9b1b-f2e6-4138-8e58-5919a9d1e61b"
  client_id       = "bbbfaa48-7794-4cdf-ae72-9011edcaebf5"
  client_secret   = "zWU8Q~jr93vefupZlkn2WwqBWY_6EK1mxd2yhczW"
  tenant_id       = "486efef4-96af-4776-aaf2-fea23d7f1820"
  features {}
}

# Azure Resource Group
resource "azurerm_resource_group" "hiverg" {
  name     = "hiverg"
  location = "North Europe"
}

# Azure Storage Account
resource "azurerm_storage_account" "hivestora" {
  name                     = "hivestora"
  resource_group_name      = "hiverg"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Azure Databricks Workspace
resource "azurerm_databricks_workspace" "hiveDatab" {
  name                        = "hiveDatab"
  resource_group_name         = "hiverg"
  location                    = "North Europe"
  sku                         = "standard"
  managed_resource_group_name = "managedRG"
}

# Azure Key Vault
resource "azurerm_key_vault" "hivedatakeyvault" {
  name                        = "hivedatakeyvault"
  location                    = "North Europe"
  resource_group_name         = "hiverg"
  tenant_id                   = "486efef4-96af-4776-aaf2-fea23d7f1820"
  sku_name                    = "standard"
}

