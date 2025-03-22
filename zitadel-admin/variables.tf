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

variable "zitadel_domain" {
  type = string
}

variable "zitadel_jwt" {
  type      = string
  sensitive = true
}

variable "brevo_username" {
  type      = string
  sensitive = true
}

variable "brevo_password" {
  type      = string
  sensitive = true
}

variable "zitadel_github_ipd_client_id" {
  type      = string
  sensitive = true
}

variable "zitadel_github_ipd_client_secret" {
  type      = string
  sensitive = true
}

variable "vault_domain" {
  type      = string
  sensitive = true
}
