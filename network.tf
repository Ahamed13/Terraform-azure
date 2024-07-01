resource "azurerm_virtual_network" "tr-virtual-network" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  depends_on = [ 
    azurerm_resource_group.tf-rgrp 
    ]
}

# Creating SubnetA
resource "azurerm_subnet" "tr-subnets" {
  # count = var.number_of_subnets
  name                 = "subnetA"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints = ["Microsoft.Storage"]
  depends_on = [ 
    azurerm_virtual_network.tr-virtual-network
   ]
}
# Create Network Security Group
resource "azurerm_network_security_group" "tr-nsg" {
  name                = "app-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "app-rule"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
depends_on = [
  azurerm_resource_group.tf-rgrp
]
}

resource "azurerm_subnet_network_security_group_association" "tr-subnetassociationnsg" {
  # count = var.number_of_subnets
  subnet_id                 = azurerm_subnet.tr-subnets.id
  network_security_group_id = azurerm_network_security_group.tr-nsg.id
  depends_on = [
    azurerm_network_security_group.tr-nsg,
    azurerm_subnet.tr-subnets]
}

# Create IP Address
resource "azurerm_public_ip" "tr-ip" {
  # count = var.number_of_machines
  name                = "app-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  depends_on = [ 
    azurerm_resource_group.tf-rgrp
 ]
}

# Creating Network Interface
resource "azurerm_network_interface" "tr-appnetworkinterface" {
  # count = var.number_of_machines
  name                = "appnetworkinterface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tr-subnets.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.tr-subnets,
   ]
}

# data "azurerm_key_vault" "tr-data-keyvault" {
#   name                = "appkeyvault20002000"
#   resource_group_name = "new-grp"
# }

# data "azurerm_key_vault_secret" "tr-data-screte" {
#   name         = "vmpassword"
#   key_vault_id = data.azurerm_key_vault.tr-data-keyvault.id
# }

# Creating Windows Machine
resource "azurerm_windows_virtual_machine" "ap-vm" {
  # count = var.number_of_machines
  name                = "appvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2S_v3"
  admin_username      = "adminuser"
  admin_password =  "Azureahamed@98"
  # admin_password      = data.azurerm_key_vault_secret.tr-data-screte.value
  # availability_set_id = azurerm_availability_set.tr-avset.id
  network_interface_ids = [
    azurerm_network_interface.tr-appnetworkinterface.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.tr-appnetworkinterface,
    azurerm_resource_group.tf-rgrp
  ]
}