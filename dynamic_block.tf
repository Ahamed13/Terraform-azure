locals {
    resource_group_name = "app-grp"
    location = "East US"

    virtual_network = {
        name = "app-network"
        address_space = "10.0.0.0/16"
  }

    networksecuritygroup-rule = [
        {
            priority = 200
            destination_port_range = "3389"
        },
        {
            priority = 300
            destination_port_range = "80"
        }
    ]
}


resource "azurerm_resource_group" "tr-app-rgp" {
  name     = local.resource_group_name
  location = local.location
}


resource "azurerm_virtual_network" "tr-virtual-network" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  depends_on = [ 
    azurerm_resource_group.tr-app-rgp
    ]
}

resource "azurerm_network_security_group" "tr-nsg" {
  name                = "app-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  dynamic security_rule{

    for_each = local.networksecuritygroup-rule

    content {
        name = "Allow-${security_rule.value.destination_port_range}"
        priority = security_rule.value.priority
        destination_port_range = security_rule.value.destination_port_range
        direction = "Inbound"
        access    = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  }
depends_on = [
  azurerm_resource_group.tr-app-rgp
]
}