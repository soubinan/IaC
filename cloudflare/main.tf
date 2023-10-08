resource "cloudflare_record" "blog" {
  zone_id = var.zone_id
  name    = "blog"
  value   = "hashnode.network"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_bot_management" "anti_bot" {
  zone_id    = var.zone_id
  enable_js  = true
  fight_mode = true
}
