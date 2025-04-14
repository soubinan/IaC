variable "harbor_username" {
  type = string
}

variable "harbor_password" {
  type      = string
  sensitive = false
}

variable "harbor_docker_user" {
  type      = string
  sensitive = true
}

variable "harbor_docker_pat" {
  type      = string
  sensitive = true
}
