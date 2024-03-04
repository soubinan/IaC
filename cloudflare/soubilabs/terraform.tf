terraform {
  cloud {
    organization = "SoubiLabs"
    workspaces {
      name = "Cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.18"
    }
  }
}

provider "cloudflare" {}
