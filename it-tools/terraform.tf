terraform {
  backend "s3" {
    bucket = "operations"
    key    = "tf_states/lxc/it_tools.tfstate"
    region = "main"

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }

  required_providers {
    proxmox = {
      version = "~> 0.69"
      source  = "bpg/proxmox"
    }
  }
}
