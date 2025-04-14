# TODO: Unify all outputs data into one structured file
resource "local_sensitive_file" "zitadel_outputs" {
  content = jsonencode({
    sno = {
      clientId     = zitadel_application_oidc.sno.client_id,
      clientSecret = zitadel_application_oidc.sno.client_secret,
    },
    vault_infra = {
      clientId     = zitadel_application_oidc.vault_infra.client_id,
      clientSecret = zitadel_application_oidc.vault_infra.client_secret,
    },
    harbor = {
      clientId     = zitadel_application_oidc.harbor_registry.client_id,
      clientSecret = zitadel_application_oidc.harbor_registry.client_secret,
    },
    argocd = {
      clientId     = zitadel_application_oidc.argocd.client_id,
      clientSecret = zitadel_application_oidc.argocd.client_secret,
    },
    argowf = {
      clientId     = zitadel_application_oidc.argowf.client_id,
      clientSecret = zitadel_application_oidc.argowf.client_secret,
    },
  })

  filename = "${path.module}/.creds.zitadel_outputs.json"

  depends_on = [
    zitadel_application_oidc.sno,
    zitadel_application_oidc.vault_infra,
    zitadel_application_oidc.harbor_registry,
    zitadel_application_oidc.argocd,
    zitadel_application_oidc.argowf,
  ]
}
