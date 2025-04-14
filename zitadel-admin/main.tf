provider "zitadel" {
  domain           = var.zitadel_domain
  insecure         = "false"
  port             = "443"
  jwt_profile_file = var.zitadel_jwt
}

locals {
  zitadel_server_url = "https://${var.zitadel_domain}"
}

############################################################# HOMELAB ORG #############################################################

resource "zitadel_org" "lab" {
  name       = "soubilabs.xyz"
  is_default = true
}

resource "zitadel_org_metadata" "lab_org_info" {
  org_id = zitadel_org.lab.id

  for_each = {
    layer   = "infrastructure"
    target  = "internal, external"
    purpose = "homelab"
  }

  key   = each.key
  value = each.value

  depends_on = [zitadel_org.lab]
}

resource "zitadel_default_login_policy" "default" {
  passwordless_type             = "PASSWORDLESS_TYPE_ALLOWED"
  force_mfa                     = false
  force_mfa_local_only          = false
  multi_factors                 = ["MULTI_FACTOR_TYPE_U2F_WITH_VERIFICATION"]
  second_factors                = ["SECOND_FACTOR_TYPE_OTP", "SECOND_FACTOR_TYPE_OTP_EMAIL", "SECOND_FACTOR_TYPE_U2F"]
  password_check_lifetime       = "240h0m0s"
  external_login_check_lifetime = "240h0m0s"
  mfa_init_skip_lifetime        = "720h0m0s"
  multi_factor_check_lifetime   = "12h0m0s"
  second_factor_check_lifetime  = "24h0m0s"
  user_login                    = true
  allow_register                = false
  allow_external_idp            = true
  hide_password_reset           = false
  allow_domain_discovery        = true
  ignore_unknown_usernames      = true
  disable_login_with_email      = false
  disable_login_with_phone      = false
  default_redirect_uri          = ""
}

resource "zitadel_smtp_config" "sender" {
  sender_address   = "admin@soubilabs.xyz"
  sender_name      = "Soubilabs"
  tls              = true
  host             = "smtp-relay.brevo.com:587"
  user             = var.brevo_username
  password         = var.brevo_password
  reply_to_address = "admin@soubilabs.xyz"
  set_active       = true
}

resource "zitadel_org_idp_github" "default" {
  org_id              = zitadel_org.lab.id
  name                = "GitHub"
  client_id           = var.zitadel_github_ipd_client_id
  client_secret       = var.zitadel_github_ipd_client_secret
  scopes              = ["openid", "profile", "email"]
  is_linking_allowed  = false
  is_creation_allowed = true
  is_auto_creation    = true
  is_auto_update      = true
  auto_linking        = "AUTO_LINKING_OPTION_USERNAME"
}

resource "zitadel_project" "internal" {
  org_id                   = zitadel_org.lab.id
  name                     = "internal"
  project_role_assertion   = true
  project_role_check       = true
  has_project_check        = true
  private_labeling_setting = "PRIVATE_LABELING_SETTING_ENFORCE_PROJECT_RESOURCE_OWNER_POLICY"
}

resource "zitadel_project" "external" {
  org_id                   = zitadel_org.lab.id
  name                     = "external"
  project_role_assertion   = true
  project_role_check       = true
  has_project_check        = true
  private_labeling_setting = "PRIVATE_LABELING_SETTING_ENFORCE_PROJECT_RESOURCE_OWNER_POLICY"
}

resource "zitadel_project_role" "lab_roles" {
  org_id = zitadel_org.lab.id

  for_each = {
    "infra-admins" = {
      project_id   = zitadel_project.internal.id
      display_name = "Infra Admins"
    }
    "infra-users" = {
      project_id   = zitadel_project.internal.id
      display_name = "Infra Users"
    }
    "dev-users" = {
      project_id   = zitadel_project.external.id
      display_name = "Dev Users"
    }
  }

  project_id   = each.value.project_id
  role_key     = each.key
  display_name = each.value.display_name
  group        = each.key

  depends_on = [zitadel_org.lab]
}

resource "zitadel_action" "flat_roles" {
  org_id          = zitadel_org.lab.id
  name            = "flatRoles"
  script          = <<-EOT
  /**
  * Sets the roles as an additional claim in the token with roles as the value and project as the key.
  *
  * The role claims of the token look like the following:
  *
  * // Added by the code below
  * "grants": ["{projectId}:{roleName}", "{projectId}:{roleName}", ...],
  * "roles": ["{roleName}", "{roleName}", ...],
  * // added automatically
  * "urn:zitadel:iam:org:project:roles": {
  *   "asdf": {
  *     "201982826478953724": "zitadel.localhost"
  *   }
  * }
  *
  * Flow: Complement token, Triggers: Pre Userinfo creation, Pre access token creation
  *
  * @param ctx
  * @param api
  */
  function flatRoles(ctx, api) {
      if (ctx.v1.user.grants === undefined || ctx.v1.user.grants.count == 0) {
          return;
      }
      let grants = [];
      let roles = [];
      ctx.v1.user.grants.grants.forEach(claim => {
          claim.roles.forEach(role => {
              grants.push(claim.projectId + ':' + role)
              roles.push(role)
          })
      })
      api.v1.claims.setClaim('grants', grants)
      api.v1.claims.setClaim('roles', roles)
  }
  EOT
  timeout         = "10s"
  allowed_to_fail = true
}

resource "zitadel_trigger_actions" "flat_roles_trigger_customize_token_pre_userinfo_creation" {
  org_id       = zitadel_org.lab.id
  flow_type    = "FLOW_TYPE_CUSTOMISE_TOKEN"
  trigger_type = "TRIGGER_TYPE_PRE_USERINFO_CREATION"
  action_ids   = [zitadel_action.flat_roles.id]
}

resource "zitadel_trigger_actions" "flat_roles_trigger_customize_token_pre_access_token_creation" {
  org_id       = zitadel_org.lab.id
  flow_type    = "FLOW_TYPE_CUSTOMISE_TOKEN"
  trigger_type = "TRIGGER_TYPE_PRE_ACCESS_TOKEN_CREATION"
  action_ids   = [zitadel_action.flat_roles.id]
}
