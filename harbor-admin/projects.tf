locals {
  registries = {
    dockerhub = {
      provider_name = "docker-hub"
      endpoint_url  = "https://hub.docker.com"
      access_id     = var.harbor_docker_user
      access_secret = var.harbor_docker_pat
    },
    quay = {
      provider_name = "quay"
      endpoint_url  = "https://quay.io"
      access_id     = null
      access_secret = null
    },
    ghcr = {
      provider_name = "github"
      endpoint_url  = "https://ghcr.io"
      access_id     = null
      access_secret = null
    },
  }

  projects = {
    dev = {
      public                      = false
      vulnerability_scanning      = true
      enable_content_trust        = false
      enable_content_trust_cosign = true
      auto_sbom_generation        = true
      deployment_security         = "high"
    }
    prod = {
      public                      = false
      vulnerability_scanning      = true
      enable_content_trust        = false
      enable_content_trust_cosign = true
      auto_sbom_generation        = true
      deployment_security         = "medium"
    }
  }
}

resource "harbor_registry" "registries" {
  for_each = local.registries

  provider_name = each.value.provider_name
  name          = each.key
  endpoint_url  = each.value.endpoint_url
  access_id     = each.value.access_id
  access_secret = each.value.access_secret
}

resource "harbor_project" "proxied_projects" {
  for_each = local.registries

  name        = each.key
  registry_id = harbor_registry.registries[each.key].registry_id
  public      = true
}

resource "harbor_project" "projects" {
  for_each = local.projects

  name                        = each.key
  public                      = each.value.public
  vulnerability_scanning      = each.value.vulnerability_scanning
  enable_content_trust        = each.value.enable_content_trust
  enable_content_trust_cosign = each.value.enable_content_trust_cosign
  auto_sbom_generation        = each.value.auto_sbom_generation
  deployment_security         = each.value.deployment_security
}
