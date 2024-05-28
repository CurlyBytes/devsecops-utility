
terraform {
  #minimum terraform version to run
  required_version = ">= 1.5.5"

  #library/modules need to be call
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.104.2"
    }
  }
}

module "aztf_rnd_rg" {
    # source        = "../terraform/components/azure-resource-group"
    source          = "../../components/azure-resource-group"
    PROJECT_NAME    = "devsecops-utility"
    PROJECT_ENVIRONMENT_NAME = "Sandbox"

}