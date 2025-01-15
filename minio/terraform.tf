terraform {
  cloud {
    organization = "SoubiLabs"
    workspaces {
      name = "minio"
    }
  }

  required_providers {
    minio = {
      version = "~> 3.2"
      source  = "aminueza/minio"
    }
  }
}
