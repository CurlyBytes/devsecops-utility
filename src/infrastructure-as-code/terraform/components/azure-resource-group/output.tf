output "name_output" {
  value = azurerm_resource_group.components_azure_resource_group.name
  description = "The Resource Group Name."
}

output "resource_group_id_output" {
  value = azurerm_resource_group.components_azure_resource_group.id
  description = "The Resource Group Name."
}

output "tags_output" {
  value = azurerm_resource_group.components_azure_resource_group.tags
  description = "The Tags use upon creating the Resource Group."
}

output "location_output" {
  value = azurerm_resource_group.components_azure_resource_group.location
  description = "The Region Short Name."
}