# MTA STS worker script
resource "cloudflare_worker_script" "mta_sts_script" {
  account_id = var.account_id
  name       = "mta_sts_script"
  content    = file("${path.module}/scripts/mta-sts.js")
}

resource "cloudflare_worker_domain" "soubilabs_mta_sts" {
  account_id = var.account_id
  zone_id    = var.soubilabs_zone_id
  hostname   = "mta-sts.${var.soubilabs_domain}"
  service    = cloudflare_worker_script.mta_sts_script.name
}

resource "cloudflare_worker_route" "soubilabs_mta_sts_route" {
  zone_id     = var.soubilabs_zone_id
  pattern     = "mta-sts.${var.soubilabs_domain}/*"
  script_name = cloudflare_worker_script.mta_sts_script.name

  depends_on = [
    cloudflare_worker_domain.soubilabs_mta_sts,
    cloudflare_worker_script.mta_sts_script
  ]
}

# LXC HomeLab inventory worker script
resource "cloudflare_worker_script" "homelab_lxc_script" {
  account_id = var.account_id
  name       = "homelab_lxc_script"
  content    = file("${path.module}/scripts/homelab-lxc.js")
}

resource "cloudflare_worker_domain" "soubilabs_homelab_lxc" {
  account_id = var.account_id
  zone_id    = var.soubilabs_zone_id
  hostname   = "lxc-images.${var.soubilabs_domain}"
  service    = cloudflare_worker_script.homelab_lxc_script.name
}

resource "cloudflare_worker_route" "soubilabs_homelab_lxc_route" {
  zone_id     = var.soubilabs_zone_id
  pattern     = "lxc-images.${var.soubilabs_domain}/*"
  script_name = cloudflare_worker_script.homelab_lxc_script.name

  depends_on = [
    cloudflare_worker_domain.soubilabs_homelab_lxc,
    cloudflare_worker_script.homelab_lxc_script
  ]
}