locals {
    resource_group_name = "app-grp"
    location = "East US"

    common_tags={
        "Dep" = "IT"
        "tier" = 3
        "Env" = "Stagging"
    }
}

resource "azurerm_resource_group" "tr-app-rgp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "tf-storageaccount" {
  name                     = "storageahamed45786"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    for name,value in local.common_tags : name=>"${value}"
  }

  depends_on = [
    azurerm_resource_group.tr-app-rgp,
  ]
}