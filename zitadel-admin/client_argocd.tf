locals {
  argocd_url = "https://argocd.apps.okd.lab.soubilabs.xyz"
}

resource "zitadel_application_oidc" "argocd" {
  project_id = zitadel_project.internal.id
  org_id     = zitadel_org.lab.id

  name             = "argocd"
  app_type         = "OIDC_APP_TYPE_WEB"
  response_types   = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types      = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  auth_method_type = "OIDC_AUTH_METHOD_TYPE_BASIC"
  version          = "OIDC_VERSION_1_0"
  redirect_uris = [
    "${local.argocd_url}/auth/callback",
  ]
  post_logout_redirect_uris    = [local.argocd_url]
  clock_skew                   = "0s"
  dev_mode                     = false
  access_token_type            = "OIDC_TOKEN_TYPE_BEARER"
  access_token_role_assertion  = true
  id_token_role_assertion      = true
  id_token_userinfo_assertion  = true
  additional_origins           = []
  skip_native_app_success_page = true
}
