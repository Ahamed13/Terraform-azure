
# locals {
#   resource_group_name = "app-rgrp"
#   location = "East US"
#   virtual_network = {
#     name = "app-network"
#     address_space = "10.0.0.0/16"
#   }
#   subnets = [
#     {
#       name = "subnetA"
#       address_prefix = "10.0.0.0/24"
#     },
#     {
#       name = "subnetB"
#       address_prefix = "10.0.1.0/24"
#     }
#   ]
# }

resource "azurerm_resource_group" "tf-rgrp" {
  name     = local.resource_group_name
  location = local.location
}

# # resource "azurerm_storage_account" "tf-StorageAccount" {
# #   name                     = "ahamedstorage10000"
# #   resource_group_name      = azurerm_resource_group.tf-rgrp.name
# #   location                 = azurerm_resource_group.tf-rgrp.location
# #   account_tier             = "Standard"
# #   account_replication_type = "LRS"
# #   account_kind = "StorageV2"
# #   depends_on = [ 
# #     azurerm_resource_group.tf-rgrp 
# #     ]
# # }

# # resource "azurerm_storage_container" "tr-container" {
# #   name                  = "data"
# #   storage_account_name  = azurerm_storage_account.tf-StorageAccount.name
# #   container_access_type = "blob"
# #   depends_on = [ 
# #     azurerm_storage_account.tf-StorageAccount
# #    ]
# # }
# # resource "azurerm_storage_blob" "tr-blob" {
# #   name                   = "my-terraform"
# #   storage_account_name   = azurerm_storage_account.tf-StorageAccount.name
# #   storage_container_name = azurerm_storage_container.tr-container.name
# #   type                   = "Block"
# #   source                 = "azure-main.tf"
# #   depends_on = [
# #     azurerm_storage_container.tr-container
# #     ]
# # }

# resource "azurerm_virtual_network" "tr-virtual-network" {
#   name                = local.virtual_network.name
#   location            = local.location
#   resource_group_name = local.resource_group_name
#   address_space       = [local.virtual_network.address_space]
#   depends_on = [ 
#     azurerm_resource_group.tf-rgrp 
#     ]
# }

# # Creating SubnetA
# resource "azurerm_subnet" "tr-subnetA" {
#   name                 = local.subnets[0].name
#   resource_group_name  = local.resource_group_name
#   virtual_network_name = local.virtual_network.name
#   address_prefixes     = [local.subnets[0].address_prefix]
#   depends_on = [ 
#     azurerm_virtual_network.tr-virtual-network
#    ]
# }

# # Creating SubnetB
# resource "azurerm_subnet" "tr-subnetB" {
#   name                 = local.subnets[1].name
#   resource_group_name  = local.resource_group_name
#   virtual_network_name = local.virtual_network.name
#   address_prefixes     = [local.subnets[1].address_prefix]
#   depends_on = [ 
#     azurerm_virtual_network.tr-virtual-network
#    ]
# }

# # Creating Network Interface
# resource "azurerm_network_interface" "tr-appnetworkinterface" {
#   name                = "appnetworkinterface"
#   location            = local.location
#   resource_group_name = local.resource_group_name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.tr-subnetA.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.tr-ip.id
#   }
#   depends_on = [
#     azurerm_subnet.tr-subnetA
#    ]
# }

# # Create IP Address
# resource "azurerm_public_ip" "tr-ip" {
#   name                = "app-ip"
#   resource_group_name = local.resource_group_name
#   location            = local.location
#   allocation_method   = "Static"
#   depends_on = [ 
#     azurerm_resource_group.tf-rgrp
#  ]
# }

# output "subnetA-id" {
#   value = azurerm_subnet.tr-subnetA.id
  
# }

# # Create Network Security Group
# resource "azurerm_network_security_group" "tr-nsg" {
#   name                = "app-nsg"
#   location            = local.location
#   resource_group_name = local.resource_group_name

#   security_rule {
#     name                       = "app-rule"
#     priority                   = 300
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# depends_on = [
#   azurerm_resource_group.tf-rgrp
# ]
# }

# resource "azurerm_subnet_network_security_group_association" "example" {
#   subnet_id                 = azurerm_subnet.tr-subnetA.id
#   network_security_group_id = azurerm_network_security_group.tr-nsg.id
#   depends_on = [ azurerm_network_security_group.tr-nsg ]
# }


# resource "tls_private_key" "privateKey" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "linuxpemkey" {
#   filename  = "privateKeylinux.pem"
#   content = tls_private_key.privateKey.private_key_pem
#   depends_on = [
#     tls_private_key.privateKey
#   ]
# }

# # Create Windows Virtual Machine
# resource "azurerm_linux_virtual_machine" "tr-appvm" {
#   name                = "appvm"
#   resource_group_name = local.resource_group_name
#   location            = local.location
#   size                = "Standard_D2S_v3"
#   admin_username      = "adminuser"
#   admin_password      = "Azureahamed@98"
#   network_interface_ids = [
#     azurerm_network_interface.tr-appnetworkinterface.id
#   ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = tls_private_key.privateKey.public_key_openssh
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }
#   depends_on = [
#     azurerm_network_interface.tr-appnetworkinterface,
#     azurerm_resource_group.tf-rgrp,
#     tls_private_key.privateKey
#   ]
# }



# # resource "azurerm_managed_disk" "tr-dataDisk" {
# #   name                 = "dataDisk"
# #   location             = local.location
# #   resource_group_name  = local.resource_group_name
# #   storage_account_type = "Standard_LRS"
# #   create_option        = "Empty"
# #   disk_size_gb         = "16"

# # }

# # resource "azurerm_virtual_machine_data_disk_attachment" "tr-dataDisk-attachement" {
# #   managed_disk_id    = azurerm_managed_disk.tr-dataDisk.id
# #   virtual_machine_id = azurerm_windows_virtual_machine.tr-appvm.id
# #   lun                = "10"
# #   caching            = "ReadWrite"
# #   depends_on = [
# #     azurerm_managed_disk.tr-dataDisk
# #   ]
# # }
