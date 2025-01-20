variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_username" {
  type      = string
  sensitive = true
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "minio_endpoint" {
  type = string
}

variable "minio_ops_ak" {
  type      = string
  sensitive = true
}

variable "minio_ops_sk" {
  type      = string
  sensitive = true
}

variable "usr_pwd" {
  type      = string
  sensitive = true
}

variable "time_zone" {
  type    = string
  default = "UTC"
}
