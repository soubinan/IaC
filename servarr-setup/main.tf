provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
}

locals {
  targeted_node_1      = "pve0"
  network_gateway      = "192.168.100.1"
  ssh_public_key       = file("~/.ssh/id_rsa.pub")
  nfs_server           = "192.168.100.9"
  nfs_media_path       = "/mnt/pool0/media"
  local_media_path     = "/mnt/media"
  nfs_downloads_path   = "/mnt/pool0/media/downloads"
  local_downloads_path = "/downloads"
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
    size         = 8
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
      nfs_media_path          = local.nfs_media_path
      local_media_path        = local.local_media_path
      nfs_downloads_path      = local.nfs_downloads_path
      local_downloads_path    = local.local_downloads_path
      src_data_0_path         = "/var/lib/radarr"
      dst_data_0_path         = "radarr/default/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "radarr/default/bazarr"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_radarr-default_output" {
  value = {
    stdout = module.radarr-default.ansible_stdout
    stderr = module.radarr-default.ansible_stderr
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
    size         = 8
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
      nfs_media_path          = local.nfs_media_path
      local_media_path        = local.local_media_path
      nfs_downloads_path      = local.nfs_downloads_path
      local_downloads_path    = local.local_downloads_path
      src_data_0_path         = "/var/lib/radarr"
      dst_data_0_path         = "radarr/anime/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "radarr/anime/bazarr"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_radarr-anime_output" {
  value = {
    stdout = module.radarr-anime.ansible_stdout
    stderr = module.radarr-anime.ansible_stderr
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
    size         = 8
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
      nfs_media_path          = local.nfs_media_path
      local_media_path        = local.local_media_path
      nfs_downloads_path      = local.nfs_downloads_path
      local_downloads_path    = local.local_downloads_path
      src_data_0_path         = "/var/lib/sonarr"
      dst_data_0_path         = "sonarr/default/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "sonarr/default/bazarr"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_sonarr-default_output" {
  value = {
    stdout = module.sonarr-default.ansible_stdout
    stderr = module.sonarr-default.ansible_stderr
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
    size         = 8
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
      nfs_media_path          = local.nfs_media_path
      local_media_path        = local.local_media_path
      nfs_downloads_path      = local.nfs_downloads_path
      local_downloads_path    = local.local_downloads_path
      src_data_0_path         = "/var/lib/sonarr"
      dst_data_0_path         = "sonarr/anime/var"
      src_data_1_path         = "/opt/bazarr/data"
      dst_data_1_path         = "sonarr/anime/bazarr"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_sonarr-anime_output" {
  value = {
    stdout = module.sonarr-anime.ansible_stdout
    stderr = module.sonarr-anime.ansible_stderr
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
    size         = 8
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
      nfs_media_path          = local.nfs_media_path
      local_media_path        = local.local_media_path
      nfs_downloads_path      = local.nfs_downloads_path
      local_downloads_path    = local.local_downloads_path
      src_data_0_path         = "/var/lib/readarr"
      dst_data_0_path         = "readarr/default/var"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_readarr-default_output" {
  value = {
    stdout = module.readarr-default.ansible_stdout
    stderr = module.readarr-default.ansible_stderr
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
    size         = 8
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
      nfs_media_path          = local.nfs_media_path
      local_media_path        = local.local_media_path
      nfs_downloads_path      = local.nfs_downloads_path
      local_downloads_path    = local.local_downloads_path
      src_data_0_path         = "/var/lib/readarr"
      dst_data_0_path         = "readarr/anime/var"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_readarr-anime_output" {
  value = {
    stdout = module.readarr-anime.ansible_stdout
    stderr = module.readarr-anime.ansible_stderr
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
      src_data_0_path         = "/var/lib/prowlarr"
      dst_data_0_path         = "prowlarr/var"
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_prowlarr_output" {
  value = {
    stdout = module.prowlarr.ansible_stdout
    stderr = module.prowlarr.ansible_stderr
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
    size         = 8
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
      starr_api_key           = var.starr_api_key
    },
  }
}

output "configure_jellyseerr_output" {
  value = {
    stdout = module.jellyseerr.ansible_stdout
    stderr = module.jellyseerr.ansible_stderr
  }
}

locals {
  servarr_ipconfigs = {
    radarr_default = {
      ip   = length(module.radarr-default.ip_addresses) > 0 ? module.radarr-default.ip_addresses[0] : null
      port = 8080
    }
    radarr_anime = {
      ip   = length(module.radarr-anime.ip_addresses) > 0 ? module.radarr-anime.ip_addresses[0] : null
      port = 8080
    }
    sonarr_default = {
      ip   = length(module.sonarr-default.ip_addresses) > 0 ? module.sonarr-default.ip_addresses[0] : null
      port = 8080
    }
    sonarr_anime = {
      ip   = length(module.sonarr-anime.ip_addresses) > 0 ? module.sonarr-anime.ip_addresses[0] : null
      port = 8080
    }
    readarr_default = {
      ip   = length(module.readarr-default.ip_addresses) > 0 ? module.readarr-default.ip_addresses[0] : null
      port = 8080
    }
    readarr_anime = {
      ip   = length(module.readarr-anime.ip_addresses) > 0 ? module.readarr-anime.ip_addresses[0] : null
      port = 8080
    }
    prowlarr = {
      ip   = length(module.prowlarr.ip_addresses) > 0 ? module.prowlarr.ip_addresses[0] : null
      port = 8080
    }
    flaresolverr = {
      ip   = length(module.startpage.ip_addresses) > 0 ? module.startpage.ip_addresses[0] : null
      port = 8191
    }
  }
}

module "startpage" {
  source = "../modules/lxc"

  providers = {
    proxmox = proxmox
  }

  root_password  = var.usr_pwd
  ssh_public_key = local.ssh_public_key

  name          = "servarr"
  targeted_node = local.targeted_node_1
  description   = "SERVARR"
  tags = [
    "internal",
    "services",
  ]

  lxc_image = {
    image_url         = "https://lxc-images.soubilabs.xyz/downloads/mafl-latest-amd64-root"
    dst_targeted_node = local.targeted_node_1
    dst_datastore_id  = "local"
    overwrite         = true
  }

  network_dns_list = [local.network_gateway]

  ip_configs = [
    {
      ip      = "192.168.100.39"
      prefix  = 25
      gateway = local.network_gateway
    }
  ]

  assigned_cores  = 2
  assigned_memory = 4048
  assigned_swap   = 1024

  disks = [{
    datastore_id = "local-lvm"
    size         = 8
  }]

  ansible_playbook = {
    path              = "./playbook/configure.yml"
    is_replayable     = true
    disable_ssh_check = true
    extra_vars = {
      servarr_fqdn            = "servarr.lab.soubilabs.xyz"
      radarr_default_ip_port  = "${local.servarr_ipconfigs.radarr_default.ip}:${local.servarr_ipconfigs.radarr_default.port}"
      radarr_default_ip       = local.servarr_ipconfigs.radarr_default.ip
      radarr_anime_ip_port    = "${local.servarr_ipconfigs.radarr_anime.ip}:${local.servarr_ipconfigs.radarr_anime.port}"
      radarr_anime_ip         = local.servarr_ipconfigs.radarr_anime.ip
      sonarr_default_ip_port  = "${local.servarr_ipconfigs.sonarr_default.ip}:${local.servarr_ipconfigs.sonarr_default.port}"
      sonarr_default_ip       = local.servarr_ipconfigs.sonarr_default.ip
      sonarr_anime_ip_port    = "${local.servarr_ipconfigs.sonarr_anime.ip}:${local.servarr_ipconfigs.sonarr_anime.port}"
      sonarr_anime_ip         = local.servarr_ipconfigs.sonarr_anime.ip
      readarr_default_ip_port = "${local.servarr_ipconfigs.readarr_default.ip}:${local.servarr_ipconfigs.readarr_default.port}"
      readarr_anime_ip_port   = "${local.servarr_ipconfigs.readarr_anime.ip}:${local.servarr_ipconfigs.readarr_anime.port}"
      prowlarr_ip_port        = "${local.servarr_ipconfigs.prowlarr.ip}:${local.servarr_ipconfigs.prowlarr.port}"
      starr_api_key           = var.starr_api_key
    },
  }
}

resource "local_file" "servarr_ipconfigs" {
  content  = jsonencode(local.servarr_ipconfigs)
  filename = "${path.module}/servarr_ipconfigs.json"
}

output "configure_startpage_output" {
  value = {
    stdout = module.startpage.ansible_stdout
    stderr = module.startpage.ansible_stderr
  }
}
