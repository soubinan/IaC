# variable "proxmox_creds" {
#   type = object({
#     endpoint                = string
#     username                = string
#     password                = string
#     use_insecure_connection = bool
#   })
# }

variable "targeted_node" {
  type = string
}

variable "default_suffix" {
  type    = string
  default = "Managed by Terraform"
}

variable "description" {
  type    = string
  default = ""
}

variable "tags" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "lxc_image" {
  type = object({
    image_url         = string,
    image_name        = string,
    dst_targeted_node = string,
    dst_datastore_id  = string,
    overwrite         = bool,
  })
}

variable "network_dns" {
  type = list(string)
}

variable "is_privileged" {
  type    = bool
  default = false
}

variable "ip_configs" {
  type = list(object({
    ip      = string,
    prefix  = number,
    gateway = string,
    }
  ))
}

variable "network_interfaces" {
  type = list(object({
    name   = string,
    bridge = string,
    }
  ))
  default = [{
    name   = "veth0",
    bridge = "vmbr0"
  }]
}

variable "disks" {
  type = list(object({
    datastore_id = string,
    size         = number,
    }
  ))
}

variable "ssh_public_key" {
  type = string
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "architecture" {
  type    = string
  default = "amd64"
}

variable "os_type" {
  type    = string
  default = "debian"
}

variable "assigned_cores" {
  type = number
}

variable "assigned_memory" {
  type = number
}

variable "assigned_swap" {
  type = number
}

variable "enable_nfs" {
  type    = bool
  default = false
}

variable "ansible_playbook" {
  type = object({
    path              = string,
    is_replayable     = bool,
    vars              = map(string),
    disable_ssh_check = bool,
  })
  default = {
    path              = ""
    is_replayable     = true,
    vars              = {},
    disable_ssh_check = false,
  }
}
