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