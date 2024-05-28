module "standard_naming_helper" {
    source        = "../helper-naming"

    PROJECT_NAME = local.project_name
    PROJECT_DESCRIPTION = local.project_description
    PROJECT_ENVIRONMENT_NAME = local.project_environment_name
    AZURE_REGION_NAME_SHORT = local.azure_region_name_short
    AZURE_RESOURCE_TYPE_PREFIX = local.azure_resource_type_prefix
    AZURE_ADDITIONAL_TAGS = local.tags
}

resource "azurerm_resource_group" "components_azure_resource_group" {

  name      = local.standard_resource_group_name
  location  = local.standard_resource_group_location
  tags      = local.standard_resource_group_tags
  
  lifecycle {
    precondition {
      condition     =  can(index(local.valid_region_name_mapping, local.azure_region_name_short))
      error_message = "Invalid location. Supported values are ${local.valid_region_name_to_string}."
    }
    precondition {
      condition     =  lower(local.azure_region_name_short) == local.azure_region_name_short
      error_message = "${local.azure_region_name_short} contains uppercase. Location must be lower case letters."
    }
    precondition {
      condition     = can(regex("^[a-zA-Z0-9-]+$", local.project_name))
      error_message = "${local.project_name} is invalid format. The resource group name should start with 'rg', followed by letters, hyphens, and end with digits."
    }
    postcondition {
      condition     = can(regex("^rg[-a-zA-Z0-9]+[0-9]+$", self.name))
      error_message = "${self.name} is invalid format. The resource group name should start with 'rg', followed by letters, hyphens, and end with digits."
    }
    
    ignore_changes = [
      tags["CreateOnDate"],
      tags["UpdateOnDate"]
    ]
  }
}