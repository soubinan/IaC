resource "cloudflare_record" "soubilabs_blog" {
  zone_id = var.soubilabs_zone_id
  name    = "blog"
  value   = "hashnode.network"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "soubilabs_site" {
  zone_id = var.soubilabs_zone_id
  name    = "www"
  value   = "soubinan.github.io"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "soubilabs_site" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "soubinan.github.io"
  type    = "A"
  proxied = false
}