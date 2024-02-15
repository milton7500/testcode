resource "azurerm_virtual_network" "test-vn" {
  name                = "test-vn"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [ azurerm_resource_group.resource-group ]
}

resource "azurerm_subnet" "test-subnet" {
  name                 = "test-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "test-vn"
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [ azurerm_virtual_network.test-vn ]
}

resource "azurerm_network_interface" "test-interface" {
  name                = "test-interface"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "test-subnet"
    subnet_id                     = azurerm_subnet.test-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [ azurerm_subnet.test-subnet ]
}

resource "azurerm_windows_virtual_machine" "test-vm" {
  name                = "test-vm7500"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "testing"
  admin_password      = "Azure@123"
  network_interface_ids = [
    azurerm_network_interface.test-interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [azurerm_network_interface.test-interface ]
}