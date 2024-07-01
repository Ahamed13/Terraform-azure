resource "azurerm_resource_group" "tr-app-rgp" {
  name     = local.resource_group_name
  location = local.location
}

resource "random_uuid" "tr-storageaccountidentifier" {
}

resource "azurerm_storage_account" "tf-storageaccount" {
  name                     = join("",["${var.tr-storageaccountname}", substr(random_uuid.tr-storageaccountidentifier.result,0,8)])
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  depends_on = [
    azurerm_resource_group.tr-app-rgp,
    random_uuid.tr-storageaccountidentifier
  ]
}

output "randomid" {
    value = substr(random_uuid.tr-storageaccountidentifier.result,0,8)
  
}