locals {
  harbor_addr             = "https://harbor.apps.okd.lab.soubilabs.xyz"
  harbor_oidc_credentials = try(jsondecode(file("../zitadel-admin/.creds.zitadel_outputs.json")).harbor, {})
}

provider "harbor" {
  url      = local.harbor_addr
  username = var.harbor_username
  password = var.harbor_password
}

resource "harbor_config_auth" "oidc" {
  auth_mode          = "oidc_auth"
  primary_auth_mode  = true
  oidc_name          = "zitadel"
  oidc_endpoint      = "https://iam.lab.soubilabs.xyz"
  oidc_client_id     = local.harbor_oidc_credentials.clientId
  oidc_client_secret = local.harbor_oidc_credentials.clientSecret
  oidc_scope         = "openid,email,profile"
  oidc_verify_cert   = true
  oidc_auto_onboard  = true
  oidc_user_claim    = "preferred_username"
  oidc_groups_claim  = "roles"
  oidc_admin_group   = "infra-admins"
}
