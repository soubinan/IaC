provider "prowlarr" {
  url     = local.prowlarr_endpoint
  api_key = var.starr_api_key
}

resource "prowlarr_tag" "movies" {
  label = "movies"
}

resource "prowlarr_tag" "shows" {
  label = "shows"
}

resource "prowlarr_tag" "books" {
  label = "books"
}

resource "prowlarr_tag" "anime" {
  label = "anime"
}

resource "prowlarr_tag" "default" {
  label = "default"
}

resource "prowlarr_tag" "sock5" {
  label = "sock5"
}

resource "prowlarr_tag" "flaresolverr" {
  label = "flaresolverr"
}

resource "prowlarr_application_radarr" "radarr_default" {
  name            = "radarr_default"
  sync_level      = "fullSync"
  base_url        = local.radarr_default_endpoint
  prowlarr_url    = local.prowlarr_endpoint
  api_key         = var.starr_api_key
  sync_categories = [2000, 2010, 2020, 2030, 2040, 2045, 2050, 2060, 2070, 2080, 2090, 8000]
  tags            = [prowlarr_tag.default.id, prowlarr_tag.movies.id]

  depends_on = [prowlarr_tag.default, prowlarr_tag.movies]
}

resource "prowlarr_application_radarr" "radarr_anime" {
  name            = "radarr_anime"
  sync_level      = "fullSync"
  base_url        = local.radarr_anime_endpoint
  prowlarr_url    = local.prowlarr_endpoint
  api_key         = var.starr_api_key
  sync_categories = [2000, 2010, 2020, 2030, 2040, 2045, 2050, 2060, 2070, 2080, 2090, 8000]
  tags            = [prowlarr_tag.anime.id, prowlarr_tag.movies.id]

  depends_on = [prowlarr_tag.anime, prowlarr_tag.movies]
}

resource "prowlarr_application_sonarr" "sonarr_default" {
  name            = "sonarr_default"
  sync_level      = "fullSync"
  base_url        = local.sonarr_default_endpoint
  prowlarr_url    = local.prowlarr_endpoint
  api_key         = var.starr_api_key
  sync_categories = [5000, 5010, 5050, 5030, 5040, 5045, 5050, 5060, 5070, 5080, 5090, 8000]
  tags            = [prowlarr_tag.default.id, prowlarr_tag.shows.id]

  depends_on = [prowlarr_tag.default, prowlarr_tag.shows]
}

resource "prowlarr_application_sonarr" "sonarr_anime" {
  name            = "sonarr_anime"
  sync_level      = "fullSync"
  base_url        = local.sonarr_anime_endpoint
  prowlarr_url    = local.prowlarr_endpoint
  api_key         = var.starr_api_key
  sync_categories = [5000, 5010, 5050, 5030, 5040, 5045, 5050, 5060, 5070, 5080, 5090, 8000]
  tags            = [prowlarr_tag.anime.id, prowlarr_tag.shows.id]

  depends_on = [prowlarr_tag.anime, prowlarr_tag.shows]
}

resource "prowlarr_application_readarr" "readarr_default" {
  name            = "readarr_default"
  sync_level      = "fullSync"
  base_url        = local.readarr_default_endpoint
  prowlarr_url    = local.prowlarr_endpoint
  api_key         = var.starr_api_key
  sync_categories = [7000, 7010, 7070, 7030, 7040, 7050, 7060, 8000]
  tags            = [prowlarr_tag.default.id, prowlarr_tag.books.id]

  depends_on = [prowlarr_tag.default, prowlarr_tag.books]
}

resource "prowlarr_application_readarr" "readarr_anime" {
  name            = "readarr_anime"
  sync_level      = "fullSync"
  base_url        = local.readarr_anime_endpoint
  prowlarr_url    = local.prowlarr_endpoint
  api_key         = var.starr_api_key
  sync_categories = [7000, 7010, 7070, 7030, 7040, 7050, 7060, 8000]
  tags            = [prowlarr_tag.anime.id, prowlarr_tag.books.id]

  depends_on = [prowlarr_tag.anime, prowlarr_tag.books]
}

resource "prowlarr_indexer_proxy_socks5" "torguard" {
  name     = "torguard"
  host     = var.torguard_host
  port     = var.torguard_port
  username = var.torguard_username
  password = var.torguard_password
  tags     = [prowlarr_tag.sock5.id]

  depends_on = [prowlarr_tag.sock5]
}

resource "prowlarr_indexer_proxy_flaresolverr" "flaresolverr" {
  name            = "flaresolverr"
  host            = local.flaresolverr_endpoint
  request_timeout = 180
  tags            = [prowlarr_tag.flaresolverr.id]

  depends_on = [prowlarr_tag.flaresolverr]
}
