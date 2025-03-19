# MTA STS worker script
resource "cloudflare_workers_script" "mta_sts_script" {
  account_id  = var.account_id
  script_name = "mta_sts_script"
  content     = file("${path.module}/scripts/mta-sts.js")
}

resource "cloudflare_workers_custom_domain" "soubilabs_mta_sts" {
  account_id = var.account_id
  zone_id    = var.soubilabs_zone_id
  hostname   = "mta-sts.${var.soubilabs_domain}"
  service    = cloudflare_workers_script.mta_sts_script.id
}

resource "cloudflare_worker_route" "soubilabs_mta_sts_route" {
  zone_id     = var.soubilabs_zone_id
  pattern     = "mta-sts.${var.soubilabs_domain}/*"
  script_name = cloudflare_workers_script.mta_sts_script.id

  depends_on = [
    cloudflare_workers_custom_domain.soubilabs_mta_sts,
    cloudflare_workers_script.mta_sts_script
  ]
}

# LXC HomeLab inventory worker script
resource "cloudflare_workers_script" "homelab_lxc_script" {
  account_id  = var.account_id
  script_name = "homelab_lxc_script"
  content     = file("${path.module}/scripts/homelab-lxc.js")
}

resource "cloudflare_workers_custom_domain" "soubilabs_homelab_lxc" {
  account_id = var.account_id
  zone_id    = var.soubilabs_zone_id
  hostname   = "lxc-images.${var.soubilabs_domain}"
  service    = cloudflare_workers_script.homelab_lxc_script.id
}

resource "cloudflare_worker_route" "soubilabs_homelab_lxc_route" {
  zone_id     = var.soubilabs_zone_id
  pattern     = "lxc-images.${var.soubilabs_domain}/*"
  script_name = cloudflare_workers_script.homelab_lxc_script.id

  depends_on = [
    cloudflare_workers_custom_domain.soubilabs_homelab_lxc,
    cloudflare_workers_script.homelab_lxc_script
  ]
}
