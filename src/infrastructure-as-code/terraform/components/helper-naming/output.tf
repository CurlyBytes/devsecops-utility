output "region_code_output" {
  value = local.standard_region_code
  description = "Short Code for Region Name."
}

output "region_full_name_output" {
  value = local.standard_region_full_name
  description = "The Full Region Name."
}

output "region_short_name_output" {
  value = local.standard_region_short_name
  description = "The Short Region ."
}

output "environment_code_output" {
  value = local.standard_environment_code
  description = "Short Code for the Environment Name."
}

output "environment_name_output" {
  value = local.standard_environment_name
  description = "The Environment Name."
}

output "tags_output" {
  value = local.standard_tags
  description = "The Tags use upon creating the resources."
}

output "resource_group_name_output" {
  value = local.standard_full_name
  description = "The final resource name."
}

output "project_name_output" {
  value = local.standard_project_name
  description = "The Project Name."
}

output "project_description_output" {
  value = local.standard_project_description
  description = "The Project Description."
}

output "allowed_azure_region_name_mapping_output" {
  value = local.allowed_azure_region_name_mapping
  description = "Valid Data Center Region only."
}

output "name_output" {
  value = local.standard_full_name
  description = "The final name."
}