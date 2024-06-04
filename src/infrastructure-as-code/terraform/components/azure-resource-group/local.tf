locals {
    has_enable = var.HAS_ENABLE
    project_name = var.PROJECT_NAME
    project_description = var.PROJECT_DESCRIPTION
    project_environment_name = var.PROJECT_ENVIRONMENT_NAME
    azure_region_name_short = var.AZURE_REGION_NAME_SHORT
    azure_resource_type_prefix = var.AZURE_RESOURCE_TYPE_PREFIX
    tags = var.AZURE_ADDITIONAL_TAGS
    
    #NOTE this validation is for precondition of the name of azure resources
    valid_region_name_mapping = keys(module.standard_naming_helper.allowed_azure_region_name_mapping_output)
    valid_region_name_to_string = join(", ", keys(module.standard_naming_helper.allowed_azure_region_name_mapping_output))

    #NOTE: Value passing
    standard_resource_group_name = module.standard_naming_helper.resource_group_name_output
    standard_resource_group_location = module.standard_naming_helper.region_full_name_output
    standard_resource_group_tags = module.standard_naming_helper.tags_output
}