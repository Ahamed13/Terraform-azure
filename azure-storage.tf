# locals {
#   resource_group_name = "app-rgrp"
#   location = "East US"
# }

# resource "azurerm_resource_group" "tf-rgrp" {
#   name     = local.resource_group_name
#   location = local.location
# }

resource "azurerm_storage_account" "tf-StorageAccount" {
  name                     = "ahamedstorage10000"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["106.222.196.228"]
    virtual_network_subnet_ids = [azurerm_subnet.tr-subnets.id]
  }

  depends_on = [ 
    azurerm_resource_group.tf-rgrp 
    ]
}

resource "azurerm_storage_container" "tr-container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.tf-StorageAccount.name
  container_access_type = "blob"

  depends_on = [
    azurerm_storage_account.tf-StorageAccount
  ]
}

resource "azurerm_storage_blob" "tr-blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.tf-StorageAccount.name
  storage_container_name = "data"
  type                   = "Block"
  source                 = "IIS_Config.ps1"

  depends_on = [
    azurerm_storage_container.tr-container
  ]
}

# resource "azurerm_storage_account" "tf-StorageAccount" {
#   name                     = "azurestorage40000"
#   resource_group_name      = azurerm_resource_group.tf-rgrp.name
#   location                 = azurerm_resource_group.tf-rgrp.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind = "StorageV2"
#   depends_on = [ 
#     azurerm_resource_group.tf-rgrp 
#     ]
# }


# resource "azurerm_storage_container" "tr-container" {
#   for_each = toset(["data", "files", "documents"])
#   name                  = each.key
#   storage_account_name  = azurerm_storage_account.tf-StorageAccount.name
#   container_access_type = "blob"

#   depends_on = [
#     azurerm_storage_account.tf-StorageAccount
#   ]
# }

# resource "azurerm_storage_blob" "tr-blob" {
#   for_each = {
#     sample1 = "C:\\Users\\ahame\\Desktop\\Books\\Terraform\\temp1\\note1.txt"
#     sample2 = "C:\\Users\\ahame\\Desktop\\Books\\Terraform\\temp2\\note2.txt"
#     sample3 = "C:\\Users\\ahame\\Desktop\\Books\\Terraform\\temp3\\note3.txt"
#   }
#   name                   = "${each.key}.txt"
#   storage_account_name   = azurerm_storage_account.tf-StorageAccount.name
#   storage_container_name = "data"
#   type                   = "Block"
#   source                 = each.value

#   depends_on = [
#     azurerm_storage_container.tr-container
#   ]
# }