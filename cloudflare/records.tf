resource "cloudflare_record" "soubilabs_blog" {
  zone_id = var.soubilabs_zone_id
  name    = "blog"
  value   = "hashnode.network"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "soubilabs_www" {
  zone_id = var.soubilabs_zone_id
  name    = "www"
  value   = "soubinan.github.io"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "soubilabs_apex" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "soubinan.github.io"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "soubilabs_dmarc" {
  zone_id = var.soubilabs_zone_id
  name    = "_dmarc"
  value   = "v=DMARC1;p=none;rua=mailto:a1b8e51de9@rua.easydmarc.us;ruf=mailto:a1b8e51de9@ruf.easydmarc.us;fo=1;"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_mx_1" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "route1.mx.cloudflare.net"
  type    = "MX"
  priority = 5
}

resource "cloudflare_record" "soubilabs_mx_2" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "route2.mx.cloudflare.net"
  type    = "MX"
  priority = 11
}

resource "cloudflare_record" "soubilabs_mx_3" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "route3.mx.cloudflare.net"
  type    = "MX"
  priority = 48
}

resource "cloudflare_record" "soubilabs_spf" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  type    = "TXT"
}