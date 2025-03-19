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
      version = "~> 5.1"
    }
  }
}

provider "cloudflare" {}
