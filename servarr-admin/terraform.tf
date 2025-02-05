terraform {
  backend "s3" {
    bucket = "operations"
    key    = "tf_states/servarr.tfstate"
    region = "main"

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }

  required_providers {
    prowlarr = {
      version = "~> 2.4"
      source  = "devopsarr/prowlarr"
    }

    radarr = {
      version = "~> 2.3"
      source  = "devopsarr/radarr"
    }

    sonarr = {
      version = "~> 3.4"
      source  = "devopsarr/sonarr"
    }

    readarr = {
      version = "~> 2.1"
      source  = "devopsarr/readarr"
    }
  }
}
