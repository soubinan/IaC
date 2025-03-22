locals {
  secret_server_url = "https://${var.vault_domain}"
}

resource "zitadel_application_oidc" "vault_infra" {
  project_id = zitadel_project.internal.id
  org_id     = zitadel_org.lab.id

  name             = "vault_infra"
  app_type         = "OIDC_APP_TYPE_USER_AGENT"
  response_types   = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types      = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  auth_method_type = "OIDC_AUTH_METHOD_TYPE_NONE"
  version          = "OIDC_VERSION_1_0"
  redirect_uris = [
    "${local.secret_server_url}/ui/vault/auth/${local.zitadel_oidc_path.path}/oidc/callback",
    "${local.secret_server_url}/oidc/callback",
    "http://127.0.0.1:8250/oidc/callback",
  ]
  post_logout_redirect_uris    = [local.secret_server_url]
  clock_skew                   = "0s"
  dev_mode                     = false
  access_token_type            = "OIDC_TOKEN_TYPE_BEARER"
  access_token_role_assertion  = true
  id_token_role_assertion      = true
  id_token_userinfo_assertion  = true
  additional_origins           = []
  skip_native_app_success_page = true
}

resource "random_string" "vault_client_secret_hash" {
  length = 16
  keepers = {
    uuid = "${uuid()}"
  }
}

resource "local_sensitive_file" "vault_infra_credentials" {
  content = jsonencode({
    "client_id" : zitadel_application_oidc.vault_infra.client_id,
    "client_secret" : random_string.vault_client_secret_hash.result,
  })
  filename = "${path.module}/.creds.vault_oidc.json"

  depends_on = [zitadel_application_oidc.vault_infra]
}
