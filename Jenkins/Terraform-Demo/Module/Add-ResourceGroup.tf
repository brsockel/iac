# File : Azure-Add-ResoureceGroup-Map.tf  
# Module : Azure-Add-ResourceGroup-Map
# Teladoc Health

# Systems Engineering
# 4-18-2022

# Module used to create resource groups in Azure platform.  
# Name variable : Name of Resource group,  Value passed from calling script
# Location Variable : Azure Location, Value passed from calling Script
# Tags Variable Map : Tags to be applied to resource group after created in azure.

# Terraform Module Reference:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

resource "azurerm_resource_group" "resourcegroup" {
       name = var.name 
       location = var.location 
       tags     = var.tag
}

 output "resourcegroup" {
    value = azurerm_resource_group.resourcegroup
}

