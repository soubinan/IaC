resource "cloudflare_zone_settings_override" "soubilabs_zone_settings" {
  zone_id = var.soubilabs_zone_id

  settings {
    always_use_https         = "on"
    brotli                   = "on"
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "full"
    min_tls_version          = "1.2"

    http2                       = null
    mirage                      = null
    origin_error_page_pass_thru = null
    polish                      = null
    prefetch_preload            = null
    proxy_read_timeout          = null
    response_buffering          = null
    sort_query_string_for_cache = null
    true_client_ip_header       = null
    webp                        = null
    image_resizing              = null

    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }

    security_header {
      enabled            = true
      include_subdomains = true
      max_age            = 31536000
    }
  }
}

resource "cloudflare_zone_dnssec" "soubilabs" {
  zone_id = var.soubilabs_zone_id
}

resource "cloudflare_bot_management" "soubilabs_anti_bot" {
  zone_id    = var.soubilabs_zone_id
  enable_js  = true
  fight_mode = true
}

resource "cloudflare_ruleset" "ddos" {
  zone_id     = var.soubilabs_zone_id
  name        = "ddos_rulset"
  description = "DDOS attack shield"
  kind        = "zone"
  phase       = "ddos_l7"

  rules {
    action = "managed_challenge"
    action_parameters {
      overrides {
        sensitivity_level = "default"
      }
    }

    expression  = "(http.host eq \"${var.soubilabs_domain}\")"
    description = "Apply on all traffic going to soubilabs.xyz"
    enabled     = true
  }
}
