terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}


resource "random_string" "abinrandom" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

provider "azuredevops" {
  org_service_url = var.ado_org_service_url
  personal_access_token = "nsmuh7nzn3hjmfsptdmxs7baxemd4lcxzeegctmv6mbrbr7q2qlq"
}






