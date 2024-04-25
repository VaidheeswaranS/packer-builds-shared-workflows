terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.99.0"
    }
  }

  # TODO: This is temporary
  backend "azurerm" {
    resource_group_name  = "github-ephemeral-runner"
    storage_account_name = "buildserverartifacts"
    container_name       = "terraform-vaidhee-test"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id != null ? var.subscription_id : null
}

provider "azurerm" {
  alias           = "centralhub"
  subscription_id = "c7a48265-a097-4dd7-bd5f-877369fb2859"

  features {}
}