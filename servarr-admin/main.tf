locals {
  servarr_ipconfigs        = try(jsondecode(file("../servarr-setup/servarr_ipconfigs.json")), {})
  flaresolverr_endpoint    = "http://${local.servarr_ipconfigs.flaresolverr.ip}:${local.servarr_ipconfigs.flaresolverr.port}"
  prowlarr_endpoint        = "http://${local.servarr_ipconfigs.prowlarr.ip}:${local.servarr_ipconfigs.prowlarr.port}"
  radarr_default_endpoint  = "http://${local.servarr_ipconfigs.radarr_default.ip}:${local.servarr_ipconfigs.radarr_default.port}"
  radarr_anime_endpoint    = "http://${local.servarr_ipconfigs.radarr_anime.ip}:${local.servarr_ipconfigs.radarr_anime.port}"
  sonarr_default_endpoint  = "http://${local.servarr_ipconfigs.sonarr_default.ip}:${local.servarr_ipconfigs.sonarr_default.port}"
  sonarr_anime_endpoint    = "http://${local.servarr_ipconfigs.sonarr_anime.ip}:${local.servarr_ipconfigs.sonarr_anime.port}"
  readarr_default_endpoint = "http://${local.servarr_ipconfigs.readarr_default.ip}:${local.servarr_ipconfigs.readarr_default.port}"
  readarr_anime_endpoint   = "http://${local.servarr_ipconfigs.readarr_anime.ip}:${local.servarr_ipconfigs.readarr_anime.port}"

  qbt_host = "192.168.100.9"
  qbt_port = 30024
}
