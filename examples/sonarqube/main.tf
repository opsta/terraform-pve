# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A SINGLE NODE SONARQUBE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "remote" {
    organization = "opsta"

    workspaces {
      name = "sonarqube"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = var.pve_tls_insecure
  pm_api_url      = var.pve_api_url
  pm_user         = var.pve_user
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE PROXMOX LXC
# ---------------------------------------------------------------------------------------------------------------------

module "sonarqube" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/opsta/terraform-pve.git//modules/lxc?ref=master"
  source                 = "../../modules/lxc"

  pve_lxc_vmid           = var.pve_lxc_vmid
  pve_lxc_hostname       = var.pve_lxc_hostname
  pve_lxc_target_node    = var.pve_lxc_target_node

  pve_lxc_ostemplate     = var.pve_lxc_ostemplate
  pve_lxc_cpu_cores      = var.pve_lxc_cpu_cores
  pve_lxc_memory         = var.pve_lxc_memory
  pve_lxc_rootfs         = var.pve_lxc_rootfs
  pve_lxc_rootfs_size    = var.pve_lxc_rootfs_size
  
  pve_lxc_storage        = var.pve_lxc_storage
  pve_lxc_swap_size      = var.pve_lxc_swap_size
  pve_lxc_password       = var.pve_lxc_password
  ssh_public_keys        = var.ssh_public_keys

  pve_lxc_pool           = var.pve_lxc_pool
  pve_lxc_unprivileged   = var.pve_lxc_unprivileged
  pve_lxc_onboot         = var.pve_lxc_onboot
  pve_lxc_start          = var.pve_lxc_start
  pve_lxc_startup        = var.pve_lxc_startup

  pve_lxc_network_name   = var.pve_lxc_network_name
  pve_lxc_network_bridge = var.pve_lxc_network_bridge
  pve_lxc_network_ip     = var.pve_lxc_network_ip
  pve_lxc_network_subnet = var.pve_lxc_network_subnet
  pve_lxc_network_gw     = var.pve_lxc_network_gw

  pve_lxc_mountpoints    = var.pve_lxc_mountpoints
}
