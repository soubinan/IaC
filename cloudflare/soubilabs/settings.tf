resource "cloudflare_zone_setting" "soubilabs_zone_settings" {
  for_each = {
    always_use_https         = "on"
    brotli                   = "on"
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
    min_tls_version          = "1.2"
    opportunistic_encryption = "on"
    minify = {
      css  = "on"
      js   = "on"
      html = "on"
    }
    security_header = {
      enabled            = true
      include_subdomains = true
      max_age            = 31536000
    }
  }

  zone_id    = var.soubilabs_zone_id
  setting_id = each.key
  value      = each.value
}

# resource "cloudflare_zone_dnssec" "soubilabs" {
#   zone_id = var.soubilabs_zone_id
#   status  = "active"
# }

resource "cloudflare_bot_management" "soubilabs_anti_bot" {
  zone_id    = var.soubilabs_zone_id
  enable_js  = true
  fight_mode = true
}

# resource "cloudflare_ruleset" "ddos" {
#   zone_id     = var.soubilabs_zone_id
#   name        = "ddos_rulset"
#   description = "DDOS attack shield"
#   kind        = "zone"
#   phase       = "ddos_l7"

#   rules {
#     action = "managed_challenge"
#     action_parameters {
#       overrides {
#         sensitivity_level = "default"
#       }
#     }

#     expression  = true
#     description = "Apply on all traffic"
#     enabled     = true
#   }
# }
