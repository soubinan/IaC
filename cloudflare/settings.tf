resource "cloudflare_zone_settings_override" "soubilabs_zone_settings" {
  zone_id = var.soubilabs_zone_id

  settings {
    always_use_https         = "on"
    brotli                   = "on"
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    ssl                      = "strict"
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

resource "cloudflare_worker_domain" "soubilabs_mta_sts" {
  account_id = var.soubilabs_account_id
  zone_id    = var.soubilabs_zone_id
  hostname   = "mta-sts.${var.soubilabs_domain}"
  service    = "mta_sts_service"
}

resource "cloudflare_worker_route" "soubilabs_mta_sts_route" {
  zone_id    = var.soubilabs_zone_id
  pattern     = "mta-sts.${var.soubilabs_domain}/*"
  script_name = cloudflare_worker_script.mta_sts_script.name
}

resource "cloudflare_worker_script" "mta_sts_script" {
  account_id = var.soubilabs_account_id
  name       = "mta_sts_script"
  content    = file("${path.module}/mta-sts.js")

  service_binding {
    name        = "mta_sts"
    service     = cloudflare_worker_domain.soubilabs_mta_sts.service
    environment = "production"
  }
}
