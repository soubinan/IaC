resource "cloudflare_email_routing_settings" "soubilabs" {
  zone_id = var.soubilabs_zone_id
  enabled = "true"
}

resource "cloudflare_email_routing_address" "soubinan_gmail" {
  account_id = var.account_id
  email      = "soubinan@soubilabs.xyz"
}

resource "cloudflare_email_routing_rule" "mail_soubilabs" {
  zone_id = var.soubilabs_zone_id
  name    = "rule"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "mail@soubilabs.xyz"
  }

  action {
    type  = "forward"
    value = cloudflare_email_routing_address.soubinan_gmail.email
  }
}

resource "cloudflare_email_routing_rule" "soubinan_soubilabs" {
  zone_id = var.soubilabs_zone_id
  name    = "rule"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "soubinan@soubilabs.xyz"
  }

  action {
    type  = "forward"
    value = cloudflare_email_routing_address.soubinan_gmail.email
  }
}