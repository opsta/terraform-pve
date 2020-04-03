# ---------------------------------------------------------------------------------------------------------------------
# CREATE LXC CONTAINER ON PROXMOX
# ---------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# provider "proxmox" {
#   pm_tls_insecure = var.pve_tls_insecure
#   pm_api_url      = var.pve_api_url
#   pm_user         = var.pve_user
# }

# ---------------------------------------------------------------------------------------------------------------------
# CREATE PROXMOX LXC
# ---------------------------------------------------------------------------------------------------------------------

resource "proxmox_lxc" "container" {
  vmid            = var.pve_lxc_vmid
  hostname        = var.pve_lxc_hostname
  target_node     = var.pve_lxc_target_node

  ostemplate      = var.pve_lxc_ostemplate
  cores           = var.pve_lxc_cpu_cores
  memory          = var.pve_lxc_memory
  rootfs          = "${var.pve_lxc_rootfs}:${var.pve_lxc_rootfs_size}"
  storage         = var.pve_lxc_storage
  swap            = var.pve_lxc_swap_size
  password        = var.pve_lxc_password
  ssh_public_keys = var.ssh_public_keys

  pool            = var.pve_lxc_pool
  unprivileged    = var.pve_lxc_unprivileged
  onboot          = var.pve_lxc_onboot
  start           = var.pve_lxc_start
  startup         = var.pve_lxc_startup

  network {
    name   = var.pve_lxc_network_name
    bridge = var.pve_lxc_network_bridge
    ip     = "${var.pve_lxc_network_ip}${var.pve_lxc_network_subnet}"
    gw     = var.pve_lxc_network_gw
  }

  dynamic "mountpoint" {
    for_each = var.pve_lxc_mountpoints
    content {
      volume = mountpoint.value["volume"]
      mp     = mountpoint.value["mountpath"]
      size   = lookup(mountpoint.value, "size", null)
      backup = lookup(mountpoint.value, "backup", null)
      quota  = lookup(mountpoint.value, "quota", null)
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ANSIBLE INVENTORY
# This will automatically create Ansible Inventory in ./inventories/*.ini directory to use with Ansible to orchetrate
# build the system
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "ansible_inventory" {
  template         = "${file("${path.module}/templates/ansible_inventory.ini")}"
  vars = {
    instance_group = var.pve_lxc_hostname
    instance_host  = "${var.pve_lxc_hostname}-server ansible_user=${var.pve_lxc_ostemplate_ssh_user} ansible_host=${var.pve_lxc_network_ip} ansible_port=${var.pve_lxc_ostemplate_ssh_port}"
  }
}

resource "local_file" "ansible_inventory_file" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${var.ansible_inventory_path}/${var.pve_lxc_hostname}.ini"
}
