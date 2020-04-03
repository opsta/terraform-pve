# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# PM_PASS

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# variable "pve_tls_insecure" {
#   description = "Disable TLS verification while connecting."
#   type        = bool
#   default     = false
# }

# variable "pve_api_url" {
#   description = "This is the target Proxmox API endpoint."
#   type        = string
# }

# variable "pve_user" {
#   description = "The Proxmox's user, There is a bug on proxmox_lxc that you have to use root@pam as user for now. See https://github.com/Telmate/terraform-provider-proxmox/issues/155"
#   type        = string
#   default     = "root@pam"
# }

variable "pve_lxc_vmid" {
  description = "The (unique) ID of the VM."
  type        = string
}

variable "pve_lxc_hostname" {
  description = "Set a host name for the container."
  type        = string
}

variable "pve_lxc_target_node" {
  description = "Target node. Only allowed if the original VM is on shared storage."
  type        = string
}

variable "pve_lxc_ostemplate" {
  description = "The OS template or backup file."
  type        = string
  default     = "local:vztmpl/ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
}

variable "pve_lxc_rootfs" {
  description = "Volume do you want to use as container root."
  type        = string
  default     = "local"
}

variable "pve_lxc_rootfs_size" {
  description = "Container root disk size"
  type        = number
  default     = 8
}

variable "pve_lxc_network_ip" {
  description = "Specifies network interfaces IPV4 Address for the container. It is in format IPv4|dhcp|manual."
  type        = string
  default     = "dhcp"
}

variable "pve_lxc_network_subnet" {
  description = "Specifies network interfaces Subnet Address for the container in case of pve_lxc_network_ip is IPv4 only. It is in CIDR (eg. /8, /16, /24) format."
  type        = string
  default     = null
}

variable "pve_lxc_network_gw" {
  description = "Specifies network interfaces gateway for the container. It is in IPv4 format."
  type        = string
  default     = null
}

variable "pve_lxc_cpu_cores" {
  description = "The number of cores assigned to the container."
  type        = number
  default     = 1
}

variable "pve_lxc_memory" {
  description = "Amount of RAM for the VM in MB."
  type        = number
  default     = 512
}

variable "pve_lxc_storage" {
  description = "Default Storage."
  type        = string
  default     = "local"
}

variable "ssh_public_keys" {
  description = "Setup public SSH keys (one key per line, OpenSSH format)"
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "pve_lxc_network_name" {
  description = "Specifies network interfaces name for the container."
  type        = string
  default     = "eth0"
}

variable "pve_lxc_network_bridge" {
  description = "Specifies network interfaces bridge for the container."
  type        = string
  default     = "vmbr0"
}

variable "pve_lxc_swap_size" {
  description = "Amount of SWAP for the VM in MB."
  type        = number
  default     = 0
}

variable "pve_lxc_password" {
  description = "Sets root password inside container."
  type        = string
  default     = null
}

variable "pve_lxc_pool" {
  description = "Add the VM to the specified pool."
  type        = string
  default     = null
}

variable "pve_lxc_unprivileged" {
  description = "Makes the container run as unprivileged user."
  type        = bool
  default     = true
}

variable "pve_lxc_start" {
  description = "Start the CT after its creation finished successfully."
  type        = bool
  default     = true
}

variable "pve_lxc_startup" {
  description = "Startup and shutdown behavior. Order is a non-negative number defining the general startup order. Shutdown in done with reverse ordering. Additionally you can set the up or down delay in seconds, which specifies a delay to wait before the next VM is started or stopped."
  type        = string
  default     = null
}

variable "pve_lxc_onboot" {
  description = "Specifies whether a VM will be started during system bootup."
  type        = bool
  default     = false
}

variable "pve_lxc_ostemplate_ssh_user" {
  description = "User to SSH to ostemplate."
  type        = string
  default     = "root"
}

variable "pve_lxc_ostemplate_ssh_port" {
  description = "User to SSH to ostemplate."
  type        = number
  default     = 22
}

# MOUNTPOINT IS NOT WORKING YET.
# SEE BUG HERE https://github.com/Telmate/terraform-provider-proxmox/issues/157
variable "pve_lxc_mountpoints" {
  description = "Use volume as container mount point."
  # We can't narrow the type down more than "any" because if we use list(object(...)), then all the fields in the
  # object will be required (whereas some, such as encrypted, should be optional), and if we use list(map(...)), all
  # the values in the map must be of the same type, whereas we need some to be strings, some to be bools, and some to
  # be ints. So, we have to fall back to just any ugly "any."
  type    = any
  default = []
  # default = [
  #   {
  #     # This is Storage Backed Mount Points syntax
  #     volume    = "pve-data:40"
  #     mountpath = "/var/lib/myapp"
  #     backup    = true
  #     quota     = false
  #     # size      = 40
  #   }
  # ]
}

variable "ansible_inventory_path" {
  description = "Path where Ansible Inventory is going to generate"
  type        = string
  default     = "./inventories"
}
