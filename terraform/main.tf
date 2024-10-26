provider "azurerm" {
    features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }    
  }

  required_version = ">= 0.14.9"

  backend "azurerm" {}
}