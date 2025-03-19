resource "cloudflare_email_routing_settings" "soubilabs" {
  zone_id = var.soubilabs_zone_id
}

resource "cloudflare_email_routing_address" "soubinan_gmail" {
  account_id = var.account_id
  email      = "soubinan@gmail.com"
}

resource "cloudflare_email_routing_rule" "mail_soubilabs" {
  zone_id = var.soubilabs_zone_id
  name    = "rule"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = "mail@soubilabs.xyz"
  }]

  actions = [{
    type = "forward"
    value = [
      cloudflare_email_routing_address.soubinan_gmail.email
    ]
  }]
}

resource "cloudflare_email_routing_rule" "soubinan_soubilabs" {
  zone_id = var.soubilabs_zone_id
  name    = "rule"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = "soubinan@soubilabs.xyz"
  }]
  actions = [{
    type = "forward"
    value = [
      cloudflare_email_routing_address.soubinan_gmail.email
    ]
  }]
}
