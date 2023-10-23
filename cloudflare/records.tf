resource "cloudflare_record" "soubilabs_blog" {
  zone_id = var.soubilabs_zone_id
  name    = "blog"
  value   = "hashnode.network"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "soubilabs_blog_star" {
  zone_id = var.soubilabs_zone_id
  name    = "www.blog"
  value   = "hashnode.network"
  type    = "CNAME"
  proxied = false
}

# resource "cloudflare_record" "soubilabs_labs" {
#   zone_id = var.soubilabs_zone_id
#   name    = "labs"
#   value   = "soubinan.github.io"
#   type    = "CNAME"
#   proxied = true
# }

# resource "cloudflare_record" "soubilabs_labs_star" {
#   zone_id = var.soubilabs_zone_id
#   name    = "*.labs"
#   value   = "soubinan.github.io"
#   type    = "CNAME"
#   proxied = true
# }

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
  value   = "v=DMARC1;p=reject;pct=100;rua=mailto:be86d89b7ea440ccb7a24ba9c18d7fb4@dmarc-reports.cloudflare.net,mailto:a1b8e51de9@rua.easydmarc.us;ruf=mailto:a1b8e51de9@ruf.easydmarc.us;ri=86400;aspf=s;adkim=s;fo=1"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_mx_1" {
  zone_id  = var.soubilabs_zone_id
  name     = "@"
  value    = "route1.mx.cloudflare.net"
  type     = "MX"
  priority = 5
}

resource "cloudflare_record" "soubilabs_mx_2" {
  zone_id  = var.soubilabs_zone_id
  name     = "@"
  value    = "route2.mx.cloudflare.net"
  type     = "MX"
  priority = 11
}

resource "cloudflare_record" "soubilabs_mx_3" {
  zone_id  = var.soubilabs_zone_id
  name     = "@"
  value    = "route3.mx.cloudflare.net"
  type     = "MX"
  priority = 48
}

resource "cloudflare_record" "soubilabs_spf" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_spf_www" {
  zone_id = var.soubilabs_zone_id
  name    = "www"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_dkim" {
  zone_id = var.soubilabs_zone_id
  name    = "s1._domainkey"
  value   = "v=DKIM1;t=s;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCvAW6v9kbrGXTGsgzIXvs0IHC5ZjZYpNjCmOB2LueZ3r/DsXC1LYz8w1f0rrO6Ln3fe/8zPYcV0M6NMAhJqkuvaSJrsFjcz7OJVWJKQhfY8G1bYRrD6Xau1cDQyLSnUxCWrFwH6tiZumdDv6I28NJymR17+xdwSgV3YB8LVm5AwIDAQAB"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_mtasts" {
  zone_id = var.soubilabs_zone_id
  name    = "_mta-sts"
  value   = "v=STSv1; id=169691518796Z;"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_tlsrpt" {
  zone_id = var.soubilabs_zone_id
  name    = "_smtp._tls"
  value   = "v=TLSRPTv1; rua=mailto:soubinan@gmail.com;"
  type    = "TXT"
}

########## Brevo email sender

resource "cloudflare_record" "soubilabs_brevocode" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  value   = "brevo-code:7d2cf8515804438cd0a418aca7189afa"
  type    = "TXT"
}

resource "cloudflare_record" "soubilabs_brevodkim" {
  zone_id = var.soubilabs_zone_id
  name    = "mail._domainkey"
  value   = "k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeMVIzrCa3T14JsNY0IRv5/2V1/v2itlviLQBwXsa7shBD6TrBkswsFUToPyMRWC9tbR/5ey0nRBH0ZVxp+lsmTxid2Y2z+FApQ6ra2VsXfbJP3HE6wAO0YTVEJt1TmeczhEd2Jiz/fcabIISgXEdSpTYJhb0ct0VJRxcg4c8c7wIDAQAB"
  type    = "TXT"
}