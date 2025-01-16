provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
}

locals {
  targeted_node_1 = "pve0"
  network_gateway = "192.168.100.1"
  ssh_public_key  = file("~/.ssh/id_rsa.pub")
}

module "it-tools" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "it-tools"
  targeted_node = local.targeted_node_1
  tags = [
    "tooling",
    "internal",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/it-tools-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.10"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 1
  assigned_memory = 512
  assigned_swap   = 512

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = false
    disable_ssh_check = true
    extra_vars        = {},
  }
}
