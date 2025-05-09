terraform {
  required_providers {
    proxmox = {
      version = "~> 0.69"
      source  = "bpg/proxmox"
    }

    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}

locals {
  description_default = upper(var.name)
  description         = length(var.description) > 0 ? "${var.description} - ${var.description_suffix}" : "${local.description_default} - ${var.description_suffix}"
  app_name            = length(var.name_suffix) > 0 ? "${var.name}-${var.name_suffix}" : var.name
  is_privileged       = var.enable_nfs || (var.is_privileged && !var.enable_nfs)
  ansible_extra_vars = merge(
    { app_name = var.name },
    var.ansible_playbook.extra_vars
  )
}

resource "proxmox_virtual_environment_download_file" "lxc_image" {
  count = var.lxc_image.image_url == null ? 0 : 1

  content_type        = "vztmpl"
  url                 = var.lxc_image.image_url
  file_name           = coalesce(var.save_image_as, "${var.name}.tar.xz")
  node_name           = var.lxc_image.dst_targeted_node
  datastore_id        = var.lxc_image.dst_datastore_id
  overwrite           = var.lxc_image.overwrite
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_container" "lxc_machine" {
  description = local.description
  tags        = var.tags

  node_name = var.targeted_node

  initialization {
    hostname = local.app_name

    dns {
      domain  = " "
      servers = var.network_dns_list
    }

    dynamic "ip_config" {
      for_each = var.ip_configs
      content {
        ipv4 {
          address = "${ip_config.value.ip}/${ip_config.value.prefix}"
          gateway = ip_config.value.gateway
        }
      }
    }

    user_account {
      keys = [
        trimspace(var.ssh_public_key)
      ]
      password = var.root_password
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      name   = network_interface.value.name
      bridge = network_interface.value.bridge
    }
  }

  cpu {
    architecture = var.architecture
    cores        = var.assigned_cores
  }

  memory {
    dedicated = var.assigned_memory
    swap      = var.assigned_swap
  }

  operating_system {
    template_file_id = var.template_file_id != null ? var.template_file_id : proxmox_virtual_environment_download_file.lxc_image[0].id
    type             = var.os_type
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      datastore_id = disk.value.datastore_id
      size         = disk.value.size
    }
  }


  dynamic "features" {
    for_each = var.enable_nfs ? [1] : []
    content {
      mount = ["nfs"]
    }
  }

  unprivileged = !local.is_privileged

  depends_on = [
    proxmox_virtual_environment_download_file.lxc_image,
  ]
}

resource "ansible_playbook" "configure_lxc_machine" {
  count = var.ansible_playbook.path != "" ? 1 : 0

  playbook   = var.ansible_playbook.path
  name       = var.ip_configs[0].ip
  replayable = var.ansible_playbook.is_replayable
  verbosity  = var.ansible_verbosity

  extra_vars = local.ansible_extra_vars

  depends_on = [
    proxmox_virtual_environment_container.lxc_machine,
  ]
}
