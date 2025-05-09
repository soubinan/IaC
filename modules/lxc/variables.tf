variable "targeted_node" {
  type = string
}

variable "description_suffix" {
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

variable "name_suffix" {
  type    = string
  default = ""
}

variable "template_file_id" {
  type    = string
  default = null
}

variable "lxc_image" {
  type = object({
    image_url         = string,
    dst_targeted_node = string,
    dst_datastore_id  = string,
    overwrite         = bool,
  })
  default = {
    image_url         = null,
    dst_targeted_node = null,
    dst_datastore_id  = null,
    overwrite         = false,
  }
  validation {
    condition     = (var.lxc_image.image_url != null || var.template_file_id != null)
    error_message = "Both 'lxc_image' and 'template_file_id' variables cannot be null, provide one of them."
  }
}

variable "save_image_as" {
  type    = string
  default = null
}

variable "network_dns_list" {
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
    disable_ssh_check = bool,
    extra_vars        = map(any),
  })
  default = {
    path              = ""
    is_replayable     = true,
    disable_ssh_check = false,
    extra_vars        = {},
  }
}

variable "ansible_verbosity" {
  type    = number
  default = 0
}
