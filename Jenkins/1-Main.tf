# File : Sample\Main.tf  
# Module : Azure-Add-ResourceGroup-Map
# Teladoc Health
# Systems Engineering
# 4-18-2022

# Sample Terriform  Script to call Azure-Add-ResourceGroup module.  Script will create as many resource groups as you specify in the variable map below. 
# In order for the script to work you must update two variables below:
# - ManagedResourceGroups : Variable String list of keys to process from the variable map RGS.  Items in Managed resource group are comma seperated and must 
#   explicitly match the key in the RGS Map:
#   - ["Item1"."Item2",Item3]

# - RGS : Map variable group used to format the Resource Group Name, Determine where the resource group is located and apply any tags to the resource group

# Standard Terraform provider call.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
}

# Required feature call for the azurerm module.  Ok for the call to be blank.
provider "azurerm" {
  features {}
}

# Local String list variable used to parse through the maps to create multipe groups. See above for additional details
locals {
  ManagedResourceGroups = ["1"] # Case Sensative.
}

# Mapped Variable to define the requirements to be used in creating azure resource groups
variable "rgs" {
  type = map(object({
    Tenant = string # Azure Tenenat
    # Teladoc (Commercial) - TD
    # Teladoc (Goverment)  - TG
    Environment = string # Environment of Object
    # Production – PRD
    # QA - QA 
    # STG - Stage
    # Management - MGT
    # Corporate Prod - COP 
    # Corporate Dev - COD 
    # Corporate Stage - COS
    # Corporate QA - COQ
    # Shortened to 1 Characer for VMs (OS Naming Limitation)
    Region = string # Location Based off Azure Region or internal Data Center
    # USNC - North Central US
    # All Azure Regions are Country/Area
    AZRegion = string
    # Azure Region Code
    App        = string # App/Workload  (3 Char)
    ObjectType = string
    tag        = map(string) # Azure Tag Objects.  You can add any tags you wish here, these are just a few suggested ones.
  }))
  default = {
    # Start copy here to create additional Resource Groups"  
    "sample" = {
      Tenant      = "TD"
      Environment = "SAM"
      Region      = "USE2"
      AZRegion    = "EastUS2"
      App         = "DC"
      ObjectType  = "RG"
      tag = {
        "Payer-Account-ID"    = "Payer Account ID"
        "Payer-Org"           = "Payer Organization"
        "Environment"         = "Corporate" # Applied at Management Group Level
        "Region"              = "US North Central"
        "Product-App"         = "Server Application or Function"
        "Business-owner"      = "Requesting User"
        "Business-Department" = "Requesting User Department"
        "Technical-Contact"   = " Technical Contact"
        "Deployment-Date"     = "System Deployment Date"
        "Confluence-Doc"      = "http://confluence.teladoc.net"
      }
    }
    # End Copy Here
    # Paste Additional Group Information Here
    "1" = {
      Tenant      = "BSockel"
      Environment = "Demo"
      Region      = "USE2"
      AZRegion    = "EastUS2"
      App         = "Jenkins"
      ObjectType  = "RG"
      tag = {
        "Deployment" = "Terraform"

      }
    }
  }
}

module "resourcegroup" {
  source = "./Module" # Path to Desired Module

  for_each = toset(local.ManagedResourceGroups) # Loops through all string list items in the MaganagedResoureceGroups Variable 
  name     = lower("${var.rgs[each.value].Tenant}-${var.rgs[each.value].Environment}-${var.rgs[each.value].Region}-${var.rgs[each.value].App}-${var.rgs[each.value].ObjectType}")

  location = var.rgs[each.value].AZRegion # Assigns location variable in parent module for current item being parsed
  tag      = var.rgs[each.value].tag      # Assigns Tags to tag variable in parent module to values defined in variable map above.

}

