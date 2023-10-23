resource "cloudflare_turnstile_widget" "soubilabs" {
  account_id     = var.account_id
  name           = "captcha"
  domains        = [
    var.soubilabs_domain
  ]
  mode           = "managed"
}