resource "cloudflare_record" "soubilabs_blog" {
  zone_id = var.soubilabs_zone_id
  name    = "blog"
  value   = "hashnode.network"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_zone_settings_override" "soubilabs_https" {
  zone_id = var.soubilabs_zone_id
  settings {
    always_use_https         = "on"
    brotli                   = "on"
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
    waf                      = "on"
  }
}

resource "cloudflare_bot_management" "soubilabs_anti_bot" {
  zone_id    = var.soubilabs_zone_id
  enable_js  = true
  fight_mode = true
}
