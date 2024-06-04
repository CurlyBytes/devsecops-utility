variable "HAS_ENABLE" {
    type   = number
    description = "If set to true, it will create the resources"
    default = 1
}

variable "PROJECT_NAME" {
    type = string
    description = <<EOT
    (Required) Project Name of the resources.

    Default: example
    EOT
    default = "example"
    sensitive = false
    validation {
      condition     = length(var.PROJECT_NAME) >= 3 
      error_message = <<EOT
      Error: '${var.PROJECT_NAME}' is too short for a Project Name.

      Valid values as follows:
      - The Project Name should be more than 3 characters

      Default: example
      EOT
    }
    validation {
      condition     = length(var.PROJECT_NAME) <= 25
      error_message = <<EOT
      Error: '${var.PROJECT_NAME}' is too long for a Project Name.

      Valid values as follows:
      - The Project Name should less than 25 characters

      Default: example
      EOT
    }
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{3,25}$", var.PROJECT_NAME))
    error_message = <<EOT
    Error: '${var.PROJECT_NAME}' Did not match in the standard policy.

    Should only have:
    - start with letter
    - only contain letters, numbers, dashes or underscores
    - must be between 3 and 25 characters
    EOT
  }
}

variable "PROJECT_DESCRIPTION" {
    type = string
    description = <<EOT
    (Required) Project Description of the resources.

    Default: This is a Test Project
    EOT
    default = "This is a Test Project"
    sensitive = false
    validation {
      condition     = length(var.PROJECT_DESCRIPTION) >= 3 
      error_message = <<EOT
      Error: '${var.PROJECT_DESCRIPTION}' is too short for a Project Description.

      Valid values as follows:
      - The Project Description should be more than 3 characters

      Default: This is a Test Project
      EOT
    }
    validation {
      condition     = length(var.PROJECT_DESCRIPTION) <= 50
      error_message = <<EOT
      Error: '${var.PROJECT_DESCRIPTION}' is too long for a Project Description.

      Valid values as follows:
      - The Project Description should less than 50 characters

      Default: This is a Test Project
      EOT
    }
}

variable "PROJECT_ENVIRONMENT_NAME" {
    type = string
    description = <<EOT
    (Required) Environment Instance Name.

    Valid values as follows:
    - Sandbox
    - QualityAssurance
    - UserAcceptance
    - PreProduction
    - Production

    Default: QualityAssurance
    EOT
    default = "QualityAssurance"
    sensitive = false
    validation {
      condition     =  contains([
        "Sandbox", 
        "QualityAssurance", 
        "UserAcceptance", 
        "PreProduction", 
        "Production"], 
        var.PROJECT_ENVIRONMENT_NAME
      )
      error_message = <<EOT
      Error: '${var.PROJECT_ENVIRONMENT_NAME}' is not valid Environment name.

      Valid values as follows:
      - Sandbox
      - QualityAssurance
      - UserAcceptance
      - PreProduction
      - Production

      Default: QualityAssurance
      EOT
    }
}

variable "AZURE_REGION_NAME_SHORT" {
  type    = string
  description = <<EOT
  (Required) Valid Azure Short Region Name of the Data Center Resource Creation.

  Options:
  - southeastasia
  - eastasia

  Default: southeastasia
  EOT

  default = "southeastasia"
  sensitive = false

  validation {
    condition     = contains(["southeastasia", "eastasia"] , var.AZURE_REGION_NAME_SHORT)
    error_message = <<EOT
    Error: '${var.AZURE_REGION_NAME_SHORT}' is Invalid Azure Short Region Name.

    Valid values as follows:
    - southeastasia
    - eastasia

    Default: southeastasia
    EOT
  }

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,20}$", var.AZURE_REGION_NAME_SHORT))
    error_message = <<EOT
    Error: '${var.AZURE_REGION_NAME_SHORT}' Did not match in the standard policy.

    Should only have:
    - start with letter
    - only contain letters, numbers, dashes or underscores
    - must be between 1 and 20 characters
    EOT
  }
}

variable "AZURE_RESOURCE_TYPE_PREFIX" {
  type    = string
  description = <<EOT
  (Required) The prefix name of the resource

  Options:
  - rg
  - web

  Default: rg
  EOT

  default = "rg"
  sensitive = false

  validation {
    condition     = contains(["rg", "web"] , var.AZURE_RESOURCE_TYPE_PREFIX)
    error_message = <<EOT
    Error: '${var.AZURE_RESOURCE_TYPE_PREFIX}' is Invalid Azure Prefix Name.

    Valid values as follows:
    - rg
    - web

    Default: rg
    EOT
  }

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,20}$", var.AZURE_RESOURCE_TYPE_PREFIX))
    error_message = <<EOT
    Error: '${var.AZURE_RESOURCE_TYPE_PREFIX}' Did not match in the standard policy.

    Should only have:
    - start with letter
    - only contain letters, numbers, dashes or underscores
    - must be between 1 and 20 characters
    EOT
  }
}

variable "AZURE_ADDITIONAL_TAGS" {
  type    = map(string)
  description = <<EOT
  (Required) Tagging of Azure Resources.

  This Key Tags should be declare:
  - OrganizationName
  - ServiceRequestTicketId
  - ProductOwner
  - BudgetAmount
  - SecurityLevel
  - Impact
  - OwnByDepartment
  - CostCenter
  - CommitHashId
  - SemanticVersionNumber
  - DeleteOnDate

  Default: 
    OrganizationName = "rafimfi"  ,
    ServiceRequestTicketId = "NA",
    ProductOwner = "francisco.abayon@rafi.ph",
    BudgetAmount = "5000"
    SecurityLevel = "internal"
    Impact = "essential"
    OwnByDepartment = "itu",
    CostCenter = "itu",
    CommitHashId =  "randomhas",
    SemanticVersionNumber = "Today" 
    DeleteOnDate = "timestamp"
  EOT

  default = {
    OrganizationName = "rafimfi"  ,
    ServiceRequestTicketId = "NA",
    ProductOwner = "francisco.abayon@rafi.ph",
    BudgetAmount = "5000"
    SecurityLevel = "internal"
    Impact = "essential"
    OwnByDepartment = "itu",
    CostCenter = "itu",
    CommitHashId =  "randomhas",
    SemanticVersionNumber = "Today" 
    DeleteOnDate = "timestamp"
    DeleteO2nDate = "timestamp"
  }
  sensitive = false

  validation {
    condition     = length(var.AZURE_ADDITIONAL_TAGS) <= 15
    error_message = <<EOT
    Error: cannot have more than 15 tags define.

    Values: '${
      replace(
        replace(
          jsonencode(var.AZURE_ADDITIONAL_TAGS), "\"", ""
        ), ":", "="
      )}'
    EOT
  }

  validation {
    condition = alltrue(
       [for obj in keys(var.AZURE_ADDITIONAL_TAGS) : can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,25}$", obj))]
    )
    error_message = <<EOT
    Error: '${
      replace(
        replace(
          jsonencode(var.AZURE_ADDITIONAL_TAGS), "\"", ""
        ), ":", "="
      )}' is Invalid Azure Tag(Key).

    Valid values as follows:
    - only alphanumeric characters
    - accept underscores

    Default: 
      OrganizationName = "rafimfi"  ,
      ServiceRequestTicketId = "NA",
      ProductOwner = "francisco.abayon@rafi.ph",
      BudgetAmount = "5000"
      SecurityLevel = "internal"
      Impact = "essential"
      OwnByDepartment = "itu",
      CostCenter = "itu",
      CommitHashId =  "randomhas",
      SemanticVersionNumber = "Today" 
      DeleteOnDate = "timestamp"
    EOT
  }

  validation {
    condition = can(index(["rafi", "rafimfi"], var.AZURE_ADDITIONAL_TAGS["OrganizationName"]))
    error_message = <<EOT
    Error: '${var.AZURE_ADDITIONAL_TAGS["OrganizationName"]}' is not valid Organization Name Tag.

    Valid values as follows:
    - rafi
    - rafimfi

    Default: rafimfi
    EOT
  }

  validation {
    condition = can(index(["public", "internal", "private"], var.AZURE_ADDITIONAL_TAGS["SecurityLevel"]))
    error_message = <<EOT
    Error: '${var.AZURE_ADDITIONAL_TAGS["SecurityLevel"]}' is not valid Security Level Tag.

    Valid values as follows:
    - public
    - internal
    - private

    Default: internal
    EOT
  }

  validation {
    condition = can(index(["minimal", "essential", "critical"], var.AZURE_ADDITIONAL_TAGS["Impact"]))
    error_message = <<EOT
    Error: '${var.AZURE_ADDITIONAL_TAGS["Impact"]}' is not valid Impact Tag.

    Valid values as follows:
    - minimal
    - essential
    - critical

    Default: essential
    EOT
  }

  validation {
    condition = can(index(["itu", "fpg", "hcu", "ops", "bdg"], var.AZURE_ADDITIONAL_TAGS["OwnByDepartment"]))
    error_message = <<EOT
    Error: '${var.AZURE_ADDITIONAL_TAGS["OwnByDepartment"]}' is not valid Own By Department Tag.

    Valid values as follows:
    - itu
    - fpg
    - hcu
    - ops
    - bdg

    Default: itu
    EOT
  }

  validation {
    condition = can(index(["itu", "fpg", "hcu", "ops", "bdg"], var.AZURE_ADDITIONAL_TAGS["CostCenter"]))
    error_message = <<EOT
    Error: '${var.AZURE_ADDITIONAL_TAGS["CostCenter"]}' is not valid Cost Center Tag.

    Valid values as follows:
    - itu
    - fpg
    - hcu
    - ops
    - bdg

    Default: itu
    EOT
  }
}