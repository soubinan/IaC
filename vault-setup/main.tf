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

module "vault" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "vault"
  targeted_node = local.targeted_node_1
  description   = "HASHICORP VAULT"
  tags = [
    "tooling",
    "internal",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/vault-unsealed-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = false
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.12"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 4096
  assigned_swap   = 0

  disks = [{
    datastore_id = "local-lvm"
    size         = 8
  }]

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      src_configs_path        = "/etc/vault.d"
      dst_configs_path        = "vault/configs"
      src_data_path           = "/opt/vault/data"
      dst_data_path           = "vault/data"
      src_var_path            = "/var/vault"
      dst_var_path            = "vault/var"
    },
  }
}
