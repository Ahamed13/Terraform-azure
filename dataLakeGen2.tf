resource "azurerm_resource_group" "tr-app-grp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "tr-datalake" {
  name                     = "datalakeaccount2000"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  depends_on = [azurerm_resource_group.tr-app-grp]
}