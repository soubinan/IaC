variable "suffix" {
  type    = string
  default = "managed by Terraform"
}

variable "minio_endpoint" {
  type = string
}

variable "minio_username" {
  type      = string
  sensitive = true
}

variable "minio_password" {
  type      = string
  sensitive = true
}

variable "time_zone" {
  type    = string
  default = "UTC"
}
