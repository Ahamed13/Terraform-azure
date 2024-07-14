resource "azurerm_resource_group" "tf-rg" {
  name     = local.resource_group_name
  location = local.location
}


resource "azurerm_app_service_plan" "tf-webapp-servicePlan" {
  name                = "webappServicePlan1000"
  location            = local.location
  resource_group_name = local.resource_group_name

  sku {
    tier = "Standard"
    size = "B1"
  }

  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}

resource "azurerm_windows_web_app" "tr-webapp" {
  name                = "ahamedwebapp1000"
  resource_group_name = local.resource_group_name
  location            = local.location
  service_plan_id     = azurerm_app_service_plan.tf-webapp-servicePlan.id

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v6.0"
    }
  }
}