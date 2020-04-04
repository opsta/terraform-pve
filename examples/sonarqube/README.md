# Sonarqube Example

This folder shows an example of Terraform code that uses the [lxc](https://github.com/opsta/terraform-pve/tree/master/modules/lxc) module to deploy a [Sonarqube](https://www.sonarqube.org) instance in [Proxmox](https://www.proxmox.com).

## What resources does this example deploy

1. A single _all in one server_ [Sonarqube](https://www.sonarqube.org)

## Quick start

To deploy a Sonarqube instance:

1. Install [Terraform](https://www.terraform.io/).
1. Install [Go](https://golang.org/doc/install)
1. Install Terraform Promox Provider

```bash
git clone https://github.com/Telmate/terraform-provider-proxmox.git
cd terraform-provider-proxmox
go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provider-proxmox
go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provisioner-proxmox
make
mkdir -p ~/.terraform.d/plugins
cp bin/terraform-provider-proxmox ~/.terraform.d/plugins
cp bin/terraform-provisioner-proxmox ~/.terraform.d/plugins
```

1. Copy this example folder on your forked [Opsta Playbooks](https://github.com/opsta/opsta-playbook) in the `terraforms/sonarqube/` directory.
1. Open the `variables.tf` file in this folder, set the environment variables specified at the top of the file, and fill in any other variables that don't have a default and the one you want to override.
1. Run below command

```bash
# Create Sonarqube Instance
cd terraforms/sonarqube/
export PM_PASS=CHANGEME
terraform init
terraform apply -auto-approve

cd ../../
ansible-playbook -i terraform/sonarqube/inventories/sonarqube.ini \
  host-preparation-ubuntu.yml install-cfupdate.yml install-letsencrypt.yml install-sonarqube.yml
```
