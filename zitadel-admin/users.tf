resource "zitadel_human_user" "soubinan" {
  org_id            = zitadel_org.lab.id
  user_name         = "soubinan"
  first_name        = "Soubinan"
  last_name         = "KACOU"
  email             = "soubinan@soubilabs.xyz"
  is_email_verified = true
}
resource "zitadel_user_grant" "soubinan_granting_internal" {
  org_id     = zitadel_org.lab.id
  project_id = zitadel_project.internal.id
  role_keys = [
    zitadel_project_role.admins.role_key,
  ]
  user_id = zitadel_human_user.soubinan.id

  depends_on = [zitadel_human_user.soubinan]
}
