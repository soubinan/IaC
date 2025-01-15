variable "suffix" {
  type    = string
  default = "managed by Terraform"
}

variable "minio_creds" {
  type = object({
    endpoint = string
    username = string
    password = string
  })
}

variable "time_zone" {
  type    = string
  default = "UTC"
}
