resource "cloudflare_zone_settings_override" "soubilabs_https" {
  zone_id = var.soubilabs_zone_id
  settings {
    always_use_https         = "on"
    brotli                   = "on"
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
    waf                      = "on"

    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }

    security_header {
      enabled = true
      include_subdomains = true
    }
  }
}

resource "cloudflare_bot_management" "soubilabs_anti_bot" {
  zone_id    = var.soubilabs_zone_id
  enable_js  = true
  fight_mode = true
}
