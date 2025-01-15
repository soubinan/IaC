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

module "homarr" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "homarr"
  targeted_node = local.targeted_node_1
  description   = "Homarr"
  tags = [
    "tooling",
    "internal",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/homarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.2"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 1
  assigned_memory = 1024
  assigned_swap   = 512

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      src_configs_path        = "/app/data/configs"
      src_data_path           = "/data"
      src_icons_path          = "/app/public/icons"
      dst_configs_path        = "homarr/etc"
      dst_data_path           = "homarr/var"
      dst_icons_path          = "homarr/opt/icons"
    },
  }
}
