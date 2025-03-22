resource "zitadel_application_oidc" "sno" {
  project_id = zitadel_project.internal.id
  org_id     = zitadel_org.lab.id

  name                         = "sno"
  app_type                     = "OIDC_APP_TYPE_USER_AGENT"
  response_types               = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types                  = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  auth_method_type             = "OIDC_AUTH_METHOD_TYPE_NONE"
  version                      = "OIDC_VERSION_1_0"
  redirect_uris                = ["https://oauth-openshift.apps.okd.lab.soubilabs.xyz/oauth2callback/zitadel"]
  post_logout_redirect_uris    = ["https://console-openshift-console.apps.okd.lab.soubilabs.xyz"]
  clock_skew                   = "0s"
  dev_mode                     = false
  access_token_type            = "OIDC_TOKEN_TYPE_BEARER"
  access_token_role_assertion  = true
  id_token_role_assertion      = true
  id_token_userinfo_assertion  = true
  additional_origins           = []
  skip_native_app_success_page = true
}

resource "random_string" "sno_client_secret_hash" {
  length = 16
  keepers = {
    uuid = "${uuid()}"
  }
}

resource "local_sensitive_file" "sno_credentials" {
  content = jsonencode({
    "client_id" : zitadel_application_oidc.sno.client_id,
    "client_secret" : random_string.sno_client_secret_hash.result,
  })
  filename = "${path.module}/.creds.sno_oidc.json"

  depends_on = [zitadel_application_oidc.sno]
}
