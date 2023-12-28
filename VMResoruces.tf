resource "azurerm_virtual_machine" "test" {
  name                  = "testvm"
  resource_group_name   = "ODL-azure-1181277"
  location              = "East US"
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_DS1_v2"
  storage_os_disk {
    name = "testvmdisk"
    caching = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option = "FromImage"
  }
  delete_os_disk_on_termination = true
  
  delete_data_disks_on_termination = true

  storage_image_reference {
     publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter"
    version   = "latest"
  }
  os_profile {
    computer_name  = "testvm2019"
    admin_username = "leeadmin"
    admin_password = "Bl@ck#0l3009"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    "environment" = "dev"
    "tier"        = "frontend"
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vtestvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "ODL-azure-1181277"
}


resource "azurerm_subnet" "subnet1" {
  name                 = "testsubnet"
  resource_group_name  = "ODL-azure-1181277"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic1" {
  name                = "testnic"
  location            = "East US"
  resource_group_name = "ODL-azure-1181277"

  ip_configuration {
    name                          = "config1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id =azurerm_public_ip.public1.id
  }
}

resource "azurerm_public_ip" "public1" {
  name = "testblicip"
  resource_group_name = "TODL-azure-1181277"
  location = "East US"
  allocation_method = "Static"

  tags = {
    "environment" = "dev"
  }
}