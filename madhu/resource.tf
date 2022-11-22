## create resource group

resource "azurerm_resource_group" "update" {
  name     = var.resourcegroup_details.name
  location = var.resourcegroup_details.location
}

### create virtual network , depends on Resource group

resource "azurerm_virtual_network" "Vnet" {
  name                = "${var.name}-vnet"
  location            = azurerm_resource_group.update.location
  resource_group_name = azurerm_resource_group.update.name
  address_space       = var.virtualnetwork_details.address_space
  depends_on = [
    azurerm_resource_group.update
  ]
}

### create Subnet , depends on Virtual network

resource "azurerm_subnet" "subnet" {
  resource_group_name  = azurerm_resource_group.update.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  name                 = "${var.name}-subnet"
  address_prefixes     = [var.subnet_details.address_prefixes[0]]
  depends_on = [
    azurerm_virtual_network.Vnet
  ]
}

resource "azurerm_public_ip" "ippublicdev" {
  count               = var.name == "dev" ? var.numberofvms : 0
  name                = "${var.name}-ip-${count.index}"
  resource_group_name = azurerm_resource_group.update.name
  location            = azurerm_resource_group.update.location
  allocation_method   = "Dynamic"

  depends_on = [
    azurerm_subnet.subnet
  ]
}
resource "azurerm_public_ip" "ippublicqa" {
  count               = var.name == "qa" ? 1 : 0
  name                = "${var.name}-ip-${count.index}"
  resource_group_name = azurerm_resource_group.update.name
  location            = azurerm_resource_group.update.location
  allocation_method   = "Dynamic"

  depends_on = [
    azurerm_subnet.subnet
  ]
}

### create network interface

resource "azurerm_network_interface" "nicdev" {
  count               = var.name == "dev" ? var.numberofvms : 0
  name                = "${var.name}-nic-${count.index}"
  location            = azurerm_resource_group.update.location
  resource_group_name = azurerm_resource_group.update.name

  ip_configuration {
    name                          = "devipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ippublicdev[count.index].id
  }
  depends_on = [
    azurerm_subnet.subnet
  ]
}
resource "azurerm_network_interface" "nicqa" {
  count               = var.name == "qa" ? var.numberofvms : 0
  name                = "${var.name}-nic-${count.index}"
  location            = azurerm_resource_group.update.location
  resource_group_name = azurerm_resource_group.update.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.pubipqa[count.index].id
  }
  depends_on = [
    azurerm_subnet.subnet
  ]
}


### create Virtual Machine

resource "azurerm_virtual_machine" "vm" {
  count                 = var.numberofvms
  name                  = "${var.name}-vm-${count.index}"
  location              = azurerm_resource_group.update.location
  resource_group_name   = azurerm_resource_group.update.name
  network_interface_ids = var.name == "dev" ? [azurerm_network_interface.nicdev[count.index].id] : [azurerm_network_interface.nicqa[count.index].id]
  vm_size               = "Standard_B1s"
  availability_set_id   = azurerm_availability_set.test.id


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vmss1"
    admin_username = var.authentication_details.username
    admin_password = var.authentication_details.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
  depends_on = [
    azurerm_availability_set.test
  ]
}


resource "null_resource" "version1" {
  count = var.name == "dev" ? var.numberofvms : 0
  triggers = {
    version = var.null_version
  }

  provisioner "file" {
    source      = "C:/nb/ngserv.service"
    destination = "/home/madhu/ngserv.service"
    connection {
      type     = "ssh"
      user     = var.authentication_details.username
      password = var.authentication_details.password
      host     = azurerm_public_ip.ippublicdev[count.index].ip_address
      #  azurerm_public_ip.ippublicdev[count.index].id
    }
  }


  provisioner "remote-exec" {
    inline = [
      "sudo su -",
      "sudo apt update",
      "curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -",
      "sudo apt update",
      "sudo apt install nodejs -y",
      "sudo npm -v",
      "git clone https://github.com/gothinkster/angular-realworld-example-app.git",
      "cd angular-realworld-example-app/",
      "sudo npm install -g @angular/cli@8",
      "sudo npm install ",
      "cd /home/madhu/",
      "chmod 777 ngserv.service",
      "sudo -i",
      "mv /home/madhu/ngserv.service /etc/systemd/system/ngserv.service",
      "sudo systemctl start ngserv.service"

    ]
  }

  connection {
    type     = "ssh"
    user     = var.authentication_details.username
    password = var.authentication_details.password
    host     = azurerm_public_ip.ippublicdev[count.index].ip_address
    # azurerm_public_ip.ippublicdev[count.index].id 
  }

  depends_on = [
    azurerm_virtual_machine.vm
  ]
}

