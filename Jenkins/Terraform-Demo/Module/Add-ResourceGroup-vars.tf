# File : Variables.tf  
# Module : Azure-Add-ResourceGroup-Map
# Teladoc Health
# Bryan Sockel
# Systems Engineering
# 4-18-2022

# Variables Definition for the module Azure-Add-Resource Group.
# Variables are values used in this core module.  Actual values are passed from calling dcript.

variable "location" {
    type = string
}

variable "name" {
    type = string
}

variable "tag" {
    type = map(string)
}