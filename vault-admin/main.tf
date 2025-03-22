locals {
  vault_addr = "https://${var.vault_domain}"
}

provider "vault" {
  address = local.vault_addr
}

locals {
  vault_infra_credentials = try(jsondecode(file("../zitadel-admin/.creds.vault_oidc.json")), {})
  zitadel_server_url      = "https://${var.zitadel_domain}"

  roles_mapping = {
    admin = {
      policies = ["admin"]
      content_policies = {
        path         = "*"
        capabilities = ["create", "read", "update", "delete", "list", "sudo"]
      }
      bound_claim = "infra-admins"
    }
    ops = {
      policies = ["ops", "dev"]
      content_policies = {
        path         = "ops/*"
        capabilities = ["create", "read", "update", "delete", "list"]
      }
      bound_claim = "infra-users"
    }
    dev = {
      policies = ["dev"]
      content_policies = {
        path         = "devs/*"
        capabilities = ["create", "read", "update", "delete", "list"]
      }
      bound_claim = "dev-users"
    }
    viewer = {
      policies = ["viewer"]
      content_policies = {
        path         = "*"
        capabilities = []
      }
      bound_claim = "users"
    }
  }
}

data "vault_policy_document" "policies_content" {
  for_each = local.roles_mapping

  rule {
    path         = each.value.content_policies.path
    capabilities = each.value.content_policies.capabilities
  }
}

resource "vault_policy" "policies" {
  for_each = local.roles_mapping

  name   = each.key
  policy = data.vault_policy_document.policies_content[each.key].hcl
}

resource "vault_jwt_auth_backend" "zitadel" {
  path               = "zitadel_oidc"
  type               = "oidc"
  oidc_discovery_url = local.zitadel_server_url
  bound_issuer       = local.zitadel_server_url
  oidc_client_id     = local.vault_infra_credentials.client_id
  oidc_client_secret = local.vault_infra_credentials.client_secret
  default_role       = "viewer"

  tune {
    listing_visibility = "unauth"
  }
}

resource "vault_identity_group" "groups" {
  for_each = local.roles_mapping

  name     = endswith(each.key, "s") ? each.key : "${each.key}s"
  type     = "external"
  policies = each.value.policies

  metadata = {
    role = each.key
  }
}

resource "vault_identity_group_alias" "group-aliases" {
  for_each = local.roles_mapping

  name           = each.value.bound_claim
  mount_accessor = vault_jwt_auth_backend.zitadel.accessor
  canonical_id   = vault_identity_group.groups[each.key].id
}

resource "local_file" "zitadel_oidc_path" {
  content = jsonencode({
    "path" : vault_jwt_auth_backend.zitadel.path,
  })
  filename = "${path.module}/.data.zitadel_oidc_path.json"

  depends_on = [vault_jwt_auth_backend.zitadel]
}

resource "vault_jwt_auth_backend_role" "roles" {
  backend = vault_jwt_auth_backend.zitadel.path

  for_each = local.roles_mapping

  role_name      = each.key
  role_type      = "oidc"
  token_policies = each.value.policies
  oidc_scopes = [
    "openid",
    "email",
    "profile",
    "urn:zitadel:iam:user:metadata",
  ]

  bound_audiences = [local.vault_infra_credentials.client_id]
  groups_claim    = "roles"
  user_claim      = "email"

  allowed_redirect_uris = [
    "${local.vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.zitadel.path}/oidc/callback",
    "${local.vault_addr}/oidc/callback",
    "http://127.0.0.1:8250/oidc/callback",
  ]
}

resource "vault_mount" "kvs" {
  for_each = toset(["admins", "ops", "devs"])

  type = "kv"
  path = each.key

  options = {
    version = "2"
    type    = "kv-v2"
  }
}

resource "vault_auth_backend" "okd_admin" {
  type = "kubernetes"
  path = "okd_admin"
}

resource "vault_kubernetes_auth_backend_config" "okd_admin" {
  backend            = vault_auth_backend.okd_admin.path
  kubernetes_host    = file("${path.module}/.data.sno.host")
  kubernetes_ca_cert = file("${path.module}/.data.sno_ca.pem")
  issuer             = "https://kubernetes.default.svc"
  token_reviewer_jwt = file("${path.module}/.creds.token_reviewer.jwt")
}

resource "vault_kubernetes_auth_backend_role" "okd_admin" {
  backend                          = vault_auth_backend.okd_admin.path
  role_name                        = "vault-auth"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["*"]
  token_ttl                        = 3600
  token_policies                   = ["default", "admin"]
  audience                         = "vault"
}
