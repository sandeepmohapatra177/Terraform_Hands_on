resource "azurerm_public_ip" "publicip_multi" {
  count               = 2  # add count to create 2 Public IPs
  name                = "azurerm_public_ip-${count.index}" #  make names unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "NIC_multi" {
  count               = 2  #  add count to create 2 NICs
  name                = "azurerm-nic-${count.index}"  #  unique NIC names
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id  #  match NIC to correct public IP
  }
}

# associate NSG with NIC here
resource "azurerm_network_interface_security_group_association" "nic_nsg_multi" {
  count                     = 2  #  associate each NIC with NSG
  network_interface_id      = azurerm_network_interface.NIC[count.index].id #  correct NIC per index
  network_security_group_id = azurerm_network_security_group.SG.id
}

resource "azurerm_virtual_machine" "VM_multi" {
  count = 2  

  name                  = "vm-${count.index}"  # make VM names unique
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.NIC[count.index].id]  #  attach the correct NIC per VM
  vm_size               = "Standard_B2ms"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk-${count.index}"  #  make OS disk names unique
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname-${count.index}"  # unique hostnames
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

