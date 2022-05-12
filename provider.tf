terraform {
  required_providers {

  }
  backend "azurerm" {
    subscription_id      = "47f7e6d7-0e52-4394-92cb-5f106bbc647f"
    tenant_id            = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "esda-mz-refactored"
    key                  = "esda-mz-refactored.tfstate"
    #use_azuread_auth     = true
  }
  required_version = ">= 0.15"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  #subscription_id = data.azurerm_client_config.default.subscription_id
  #tenant_id       = data.azurerm_client_config.default.tenant_id
}

data "azurerm_client_config" "default" {}
