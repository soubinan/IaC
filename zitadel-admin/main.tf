provider "zitadel" {
  domain           = var.zitadel_domain
  insecure         = "false"
  port             = "443"
  jwt_profile_file = var.zitadel_jwt
}

############################################################# HOMELAB ORG #############################################################

resource "zitadel_org" "lab" {
  name = "lab.soubilabs.xyz"
}

resource "zitadel_org_metadata" "lab_org_info_layer" {
  org_id = zitadel_org.lab.id
  key    = "layer"
  value  = "infrastructure"

  depends_on = [zitadel_org.lab]
}

resource "zitadel_org_metadata" "lab_org_info_target" {
  org_id = zitadel_org.lab.id
  key    = "target"
  value  = "internal"
}

resource "zitadel_org_metadata" "lab_org_info_purpose" {
  org_id = zitadel_org.lab.id
  key    = "purpose"
  value  = "homelab"
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
  allow_external_idp            = false
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

############################################################# SOUBILABS ORG #############################################################

resource "zitadel_org" "soubilabs" {
  name = "services.soubilabs.xyz"
}

resource "zitadel_org_metadata" "soubilabs_org_info_layer" {
  org_id = zitadel_org.soubilabs.id
  key    = "layer"
  value  = "services"
}

resource "zitadel_org_metadata" "soubilabs_org_info_target" {
  org_id = zitadel_org.soubilabs.id
  key    = "target"
  value  = "external"
}

resource "zitadel_org_metadata" "soubilabs_org_info_purpose" {
  org_id = zitadel_org.soubilabs.id
  key    = "purpose"
  value  = "services"
}
