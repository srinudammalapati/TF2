resource "null_resource" "cluster" {
  count = 3
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    version = var.runingversion
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case


  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y"

    ]
    connection {
      type     = "ssh"
      host     = azurerm_linux_virtual_machine.my_vm[count.index].public_ip_address
      user     = "srinu"
      password = "devops@12345"

    }
  }
}
