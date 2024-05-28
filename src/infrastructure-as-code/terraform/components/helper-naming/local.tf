locals {
    #NOTE: Can be parameterize seperator
    separator = "-"

    #NOTE: Can be auto increment with Unique Id
    increment = "1"
    
    #NOTE: this is the supported region creation of the data center as of the moment
    allowed_azure_region_name_mapping = {
      "southeastasia" = {
        code = "sea"
        name = "Southeast Asia"
      }
      "eastasia" = {
        code = "ea"
        name = "East Asia"
      }
    }

    #NOTE: this is the environment instance as of the moment
    allowed_environment_name_mapping = {
      sandbox           = "sbx",
      qualityassurance  = "qat",
      useracceptance    = "uat",
      preproduction     = "preprod",
      production        = "prod"
    }

    #NOTE: standard are result value that need to be output
    #NOTE: region short name is southeastasia, eastasia
    standard_region_short_name = lower(var.AZURE_REGION_NAME_SHORT)
    standard_region_code = local.allowed_azure_region_name_mapping[var.AZURE_REGION_NAME_SHORT].code
    
    #NOTE: region full name is SouthEast Asia, East Asia
    standard_region_full_name = local.allowed_azure_region_name_mapping[var.AZURE_REGION_NAME_SHORT].name
    standard_environment_code = local.allowed_environment_name_mapping[
        lower(var.PROJECT_ENVIRONMENT_NAME)
    ]
    standard_environment_name = title(var.PROJECT_ENVIRONMENT_NAME)
    standard_project_name = var.PROJECT_NAME
    standard_project_description = var.PROJECT_DESCRIPTION

    #NOTE: Baseline Resource Tags
    foundation_tags = {  
      ProjectName = "${var.PROJECT_NAME}"
      ProjectDescription = "${var.PROJECT_DESCRIPTION}"
      EnvironmentName = "${local.standard_environment_code}"
      RegionName = "${local.standard_region_full_name}"
      ManagedBy = "IAC Automation"
      CreateOnDate = timestamp()
      UpdateOnDate = timestamp()
    }
    standard_tags = merge(local.foundation_tags, var.AZURE_ADDITIONAL_TAGS)
    
    #NOTE: Full Name generation prefix is rg-, sepratec name is project-name- and suffix is qat-sea-1
    separated_prefix = var.AZURE_RESOURCE_TYPE_PREFIX == "" ? "${var.PROJECT_NAME}" : "${var.AZURE_RESOURCE_TYPE_PREFIX}${local.separator}${var.AZURE_ADDITIONAL_TAGS["OrganizationName"]}${local.separator}${var.PROJECT_NAME}"
    separated_name = "${local.separator}${local.standard_environment_code}${local.separator}"
    separated_suffix = "${local.standard_region_code}${local.separator}${local.increment}"

    #NOTE: there is no seperator need such as storage account name, then remove the dash
    standard_full_name = local.separator == "" ? replace(lower("${local.separated_prefix}${local.separated_name}${local.separated_suffix}"), "-", "") : lower("${local.separated_prefix}${local.separated_name}${local.separated_suffix}")
}