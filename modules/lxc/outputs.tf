output "instance_name" {
  value = var.pve_lxc_hostname
}

output "ip_address" {
  value = var.pve_lxc_network_ip
}

output "ssh_port" {
  value = var.pve_lxc_ostemplate_ssh_port
}

output "ssh_username" {
  value = var.pve_lxc_ostemplate_ssh_user
}
