terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.99.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "github-ephemeral-runner"
    storage_account_name = "buildserverartifacts"
    container_name       = "terraform-vaidhee-test"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azurerm" {
  alias           = "centralhub"
  subscription_id = "c7a48265-a097-4dd7-bd5f-877369fb2859"

  features {}
}

provider "azuread" {}