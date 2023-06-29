variable "domain" { default = "k8s.lab" }
variable "network_cidr" {
  type    = list(any)
  default = ["192.168.100.0/24"]
}
variable "cluster_name" { default = "k8s" }
variable "libvirt_pool_path" { default = "/var/lib/libvirt/images" }
variable "bridge_name" { default = "br0" }

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "cluster" {
  name = var.cluster_name
  type = "dir"
  path = "${var.libvirt_pool_path}/${var.cluster_name}"
}

resource "libvirt_network" "kube_network" {
  autostart = true
  name      = var.cluster_name
  mode      = "bridge"
  bridge    = var.bridge_name
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "registry.terraform.io/dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

