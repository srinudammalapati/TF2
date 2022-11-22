resource "null_resource" "cluster" {
  count =2
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
      type = "ssh"
      host     = azurerm_linux_virtual_machine.vm[count.index].public_ip_address
      user     = var.vm_details.admin_username
      password = var.vm_details.admin_password
    }
  }
}
