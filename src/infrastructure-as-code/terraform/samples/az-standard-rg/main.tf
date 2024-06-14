
terraform {
  #minimum terraform version to run
  required_version = ">= 1.5.5"

  #library/modules need to be call
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "aztf_rnd_rg" {
  source                   = "../../../terraform/components/azure-resource-group"
  PROJECT_NAME             = "devsecops-utility"
  PROJECT_ENVIRONMENT_NAME = "Sandbox"

}
