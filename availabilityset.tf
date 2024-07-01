# resource "azurerm_availability_set" "tr-avset" {
#   name                = "avset"
#   location            = local.location
#   resource_group_name = local.resource_group_name
#   platform_fault_domain_count = 2
#   platform_update_domain_count = 3

#   depends_on = [
#     azurerm_resource_group.tf-rgrp
#   ]
# }