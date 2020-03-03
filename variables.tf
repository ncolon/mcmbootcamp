variable "vsphere_server" {
  type    = string
  default = "10.1.212.26"
}

variable "vsphere_username" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_allow_unverified_ssl" {
  type    = bool
  default = true
}

variable "vsphere_cluster" {
  type    = string
  default = "GSE"
}

variable "vsphere_datacenter" {
  type    = string
  default = "CSPLAB"
}

variable "vsphere_datastore" {
  type    = string
  default = "GSE"
}
variable "vsphere_network" {
  type    = string
  default = "csplab"
}

variable "vsphere_folder" {
  type    = string
  default = "GSE/MCMBootcamp"
}
variable "dns_servers" {
  type = list(string)
  default = [
    "172.16.0.11",
    "172.16.0.17"
  ]
}

variable "ipv4_address_map" {
  type = map(string)
  default = {
    user0  = "172.16.55.30"
    user1  = "172.16.55.31"
    user2  = "172.16.55.32"
    user3  = "172.16.55.33"
    user4  = "172.16.55.34"
    user5  = "172.16.55.35"
    user6  = "172.16.55.36"
    user7  = "172.16.55.37"
    user8  = "172.16.55.38"
    user9  = "172.16.55.30"
    user10 = "172.16.55.40"
    user11 = "172.16.55.41"
    user12 = "172.16.55.42"
    user13 = "172.16.55.43"
    user14 = "172.16.55.44"
    user15 = "172.16.55.45"
  }
}

variable "ipv4_gateway" {
  type    = string
  default = "172.16.255.250"
}

variable "ipv4_netmask" {
  type    = string
  default = "16"
}

variable "template" {
  type    = string
  default = "GSE/MCMBootcamp/templates/mcmbootcamp-mysql"
}

variable "username" {
  type = string
}

