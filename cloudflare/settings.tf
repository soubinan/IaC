# resource "cloudflare_zone_settings_override" "soubilabs_zone_settings" {
#   zone_id = var.soubilabs_zone_id

#   settings {
#     always_use_https         = "on"
#     brotli                   = "on"
#     tls_1_3                  = "on"
#     automatic_https_rewrites = "on"
#     ssl                      = "strict"

#     http2                       = null
#     mirage                      = null
#     origin_error_page_pass_thru = null
#     polish                      = null
#     prefetch_preload            = null
#     proxy_read_timeout          = null
#     response_buffering          = null
#     sort_query_string_for_cache = null
#     true_client_ip_header       = null
#     webp                        = null
#     image_resizing              = null

#     minify {
#       css  = "on"
#       js   = "on"
#       html = "on"
#     }

#     security_header {
#       enabled            = true
#       include_subdomains = true
#       max_age            = 31536000
#     }
#   }
# }

# resource "cloudflare_bot_management" "soubilabs_anti_bot" {
#   zone_id    = var.soubilabs_zone_id
#   enable_js  = true
#   fight_mode = true
# }


resource "cloudflare_zone_settings_override" "soubilabs_https" {
  zone_id = var.soubilabs_zone_id

  settings {
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

    ssl                      = "strict"

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