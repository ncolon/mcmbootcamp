resource "tls_private_key" "installkey" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

provider "vsphere" {
  version              = "=1.14"
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_allow_unverified_ssl
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore_cluster" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name                 = "mcmbootcamp-${var.bootcamp_user}-mysql"
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore.id
  folder               = var.vsphere_folder

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "mcmbootcamp-${var.bootcamp_user}-mysql"
        domain    = "csplab.local"
      }
      network_interface {
        ipv4_address = var.ipv4_address_map[var.bootcamp_user]
        ipv4_netmask = var.ipv4_netmask
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.dns_servers
    }
  }

  connection {
    user     = var.ssh_username
    password = var.ssh_password
    host     = var.ipv4_address_map[var.bootcamp_user]
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/tmp/terraform_scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod u+x /tmp/terraform_scripts/*.sh",
      "/tmp/terraform_scripts/add-public-ssh-key.sh \"${tls_private_key.installkey.public_key_openssh}\"",
      "/tmp/terraform_scripts/add-private-ssh-key.sh \"${tls_private_key.installkey.private_key_pem}\" \"${var.ssh_username}\""
    ]
  }
}
