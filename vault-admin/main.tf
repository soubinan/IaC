locals {
  vault_addr = "https://${var.vault_domain}"
}

provider "vault" {
  address = local.vault_addr
}

resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "null_resource" "get_sno_info" {
  provisioner "local-exec" {
    command     = <<-EOT
      cat <<EOF > .creds.sno_info.json
      {
        "host": "$(oc config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.server}')",
        "ca_pem": "$(oc config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}')",
        "token_reviewer": "$(oc get secret -n openshift-config vault-auth -o jsonpath='{.data.token}')"
      }
      EOF
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }
}

locals {
  zitadel_outputs    = try(jsondecode(file("../zitadel-admin/.creds.zitadel_outputs.json")), {})
  sno_info           = try(jsondecode(file("./.creds.sno_info.json")), {})
  zitadel_server_url = "https://${var.zitadel_domain}"

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
  oidc_client_id     = local.zitadel_outputs.vault_infra.clientId
  oidc_client_secret = local.zitadel_outputs.vault_infra.clientSecret
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

  bound_audiences = [local.zitadel_outputs.vault_infra.clientId]
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
  kubernetes_host    = local.sno_info.host
  kubernetes_ca_cert = base64decode(local.sno_info.ca_pem)
  issuer             = "https://kubernetes.default.svc"
  token_reviewer_jwt = base64decode(local.sno_info.token_reviewer)
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

resource "vault_kv_secret_v2" "creds_oidc" {
  for_each = local.zitadel_outputs

  mount = vault_mount.kvs["admins"].path
  name  = "${each.key}_oidc_client_secret_zitadel"

  data_json = jsonencode(each.value)
}
