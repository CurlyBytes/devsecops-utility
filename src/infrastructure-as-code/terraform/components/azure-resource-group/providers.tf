terraform {
  #minimum terraform version to run
  required_version = ">= 1.5.5"

  #library/modules need to be call
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
    }
  }
}
