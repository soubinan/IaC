terraform {
  backend "s3" {
    bucket = "operations"
    key    = "tf_states/zitadel.tfstate"
    region = "main"

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }

  required_providers {
    zitadel = {
      version = "~> 2.0"
      source  = "zitadel/zitadel"
    }
  }
}
