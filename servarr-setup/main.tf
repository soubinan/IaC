provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
}

locals {
  targeted_node_1 = "pve0"
  network_gateway = "192.168.100.1"
  ssh_public_key  = file("~/.ssh/id_rsa.pub")
  nfs_server      = "192.168.100.9"
}

module "radarr-default" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "radarr"
  name_suffix   = "default"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/radarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.31"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      nfs_server              = local.nfs_server
      nfs_media_path          = "/mnt/pool0/media"
      local_media_path        = "/mnt/media"
      src_data_0_path         = "/var/lib/radarr"
      dst_data_0_path         = "radarr/default/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "radarr/default/bazarr"
    },
  }
}

module "radarr-anime" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "radarr"
  name_suffix   = "anime"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/radarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.32"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      nfs_server              = local.nfs_server
      nfs_media_path          = "/mnt/pool0/media"
      local_media_path        = "/mnt/media"
      src_data_0_path         = "/var/lib/radarr"
      dst_data_0_path         = "radarr/anime/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "radarr/anime/bazarr"
    },
  }
}

module "sonarr-default" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "sonarr"
  name_suffix   = "default"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/sonarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.33"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      nfs_server              = local.nfs_server
      nfs_media_path          = "/mnt/pool0/media"
      local_media_path        = "/mnt/media"
      src_data_0_path         = "/var/lib/sonarr"
      dst_data_0_path         = "sonarr/default/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "sonarr/default/bazarr"
    },
  }
}

module "sonarr-anime" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "sonarr"
  name_suffix   = "anime"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/sonarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.34"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      nfs_server              = local.nfs_server
      nfs_media_path          = "/mnt/pool0/media"
      local_media_path        = "/mnt/media"
      src_data_0_path         = "/var/lib/sonarr"
      dst_data_0_path         = "sonarr/anime/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "sonarr/anime/bazarr"
    },
  }
}

module "readarr-default" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "readarr"
  name_suffix   = "default"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/readarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.35"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      nfs_server              = local.nfs_server
      nfs_media_path          = "/mnt/pool0/media"
      local_media_path        = "/mnt/media"
      src_data_0_path         = "/var/lib/readarr"
      dst_data_0_path         = "readarr/default/var"
    },
  }
}

module "readarr-anime" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "readarr"
  name_suffix   = "anime"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/readarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.36"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    verbosity         = 3
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      nfs_server              = local.nfs_server
      nfs_media_path          = "/mnt/pool0/media"
      local_media_path        = "/mnt/media"
      src_data_0_path         = "/var/lib/readarr"
      dst_data_0_path         = "readarr/anime/var"
    },
  }
}

module "prowlarr" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "prowlarr"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/prowlarr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.37"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      src_data_0_path         = "/var/lib/prowlarr"
      dst_data_0_path         = "prowlarr/var"
    },
  }
}

module "jellyseerr" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "jellyseerr"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/jellyseerr-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.38"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 1
  assigned_memory = 2048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 4
  }]

  enable_nfs = true

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      minio_access_key_id     = var.minio_ops_ak
      minio_secret_access_key = var.minio_ops_sk
      minio_endpoint          = var.minio_endpoint
      src_data_0_path         = "/opt/jellyseerr/config"
      dst_data_0_path         = "jellyseerr/var"
    },
  }
}
