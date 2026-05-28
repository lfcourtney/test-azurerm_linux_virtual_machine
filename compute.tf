resource "random_string" "unique_suffix" {
  length  = 6
  special = false
  upper   = false
}

# 1. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-vm-test-${random_string.unique_suffix.result}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group

  lifecycle {
    ignore_changes = [
      tags["Atlas_Project"],
      tags["Capability"],
      tags["Deployment-date"],
      tags["OwnerEmailAddress"],
      tags["Project"],
      tags["Team"]
    ]
  }
}

# 2. Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-vm-test"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 3. Public IP (To allow you to SSH into the box)
resource "azurerm_public_ip" "pip" {
  name                = "pip-vm-test-${random_string.unique_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"

  lifecycle {
    ignore_changes = [
      tags["Atlas_Project"],
      tags["Capability"],
      tags["Deployment-date"],
      tags["OwnerEmailAddress"],
      tags["Project"],
      tags["Team"]
    ]
  }
}

# 4. Network Interface (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-test-${random_string.unique_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  lifecycle {
    ignore_changes = [
      tags["Atlas_Project"],
      tags["Capability"],
      tags["Deployment-date"],
      tags["OwnerEmailAddress"],
      tags["Project"],
      tags["Team"]
    ]
  }
}

# 5. Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-test-${random_string.unique_suffix.result}"
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [
      tags["Atlas_Project"],
      tags["Capability"],
      tags["Deployment-date"],
      tags["OwnerEmailAddress"],
      tags["Project"],
      tags["Team"]
    ]
  }
}