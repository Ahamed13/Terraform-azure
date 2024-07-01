# resource "azurerm_subnet" "tr-bastion-subnets" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = local.resource_group_name
#   virtual_network_name = local.virtual_network.name
#   address_prefixes     = ["10.0.10.0/24"]
#   depends_on = [ 
#     azurerm_virtual_network.tr-virtual-network
#    ]
# }

# resource "azurerm_public_ip" "tr-bastion-ip" {
#   name                = "bastion-ip"
#   resource_group_name = local.resource_group_name
#   location            = local.location
#   allocation_method   = "Static"
#   sku = "Standard"
#   depends_on = [ 
#     azurerm_resource_group.tf-rgrp
#  ]
# }

# resource "azurerm_bastion_host" "tr-bastion" {
#   name                = "bastionhost"
#   location            = local.location
#   resource_group_name = local.resource_group_name
#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.tr-bastion-subnets.id
#     public_ip_address_id = azurerm_public_ip.tr-bastion-ip.id
#   }
#   depends_on = [
#     azurerm_public_ip.tr-bastion-ip,
#     azurerm_subnet.tr-bastion-subnets
#   ]
# }