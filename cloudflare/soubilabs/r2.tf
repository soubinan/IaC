resource "cloudflare_r2_bucket" "lxc_images" {
  account_id = var.account_id
  name       = "lxc-images"
  location   = "enam"
}