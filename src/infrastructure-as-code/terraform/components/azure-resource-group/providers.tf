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
