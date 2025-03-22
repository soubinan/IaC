provider "radarr" {
  alias   = "radarr_default"
  url     = local.radarr_default_endpoint
  api_key = var.starr_api_key
}

provider "radarr" {
  alias   = "radarr_anime"
  url     = local.radarr_anime_endpoint
  api_key = var.starr_api_key
}

resource "radarr_download_client_qbittorrent" "torrent_radarrd" {
  provider                   = radarr.radarr_default
  enable                     = true
  priority                   = 1
  name                       = "qBittorrent"
  host                       = local.qbt_host
  port                       = local.qbt_port
  movie_category             = "radarr-default"
  first_and_last             = true
  username                   = var.qbt_usr
  password                   = var.qbt_pwd
  remove_completed_downloads = true
}

resource "radarr_download_client_qbittorrent" "torrent_radarra" {
  provider                   = radarr.radarr_anime
  enable                     = true
  priority                   = 1
  name                       = "qBittorrent"
  host                       = local.qbt_host
  port                       = local.qbt_port
  movie_category             = "radarr-anime"
  first_and_last             = true
  username                   = var.qbt_usr
  password                   = var.qbt_pwd
  remove_completed_downloads = true
}

resource "radarr_root_folder" "path_radarrd" {
  provider = radarr.radarr_default
  path     = "/mnt/media/movies"
}

resource "radarr_root_folder" "path_radarra" {
  provider = radarr.radarr_anime
  path     = "/mnt/media/movies-anime"
}

resource "radarr_remote_path_mapping" "path_radarrd" {
  provider    = radarr.radarr_default
  host        = "${local.qbt_host}:${local.qbt_port}"
  remote_path = "/downloads/movies/"
  local_path  = "/downloads/movies/"
}

resource "radarr_remote_path_mapping" "path_radarra" {
  provider    = radarr.radarr_anime
  host        = "${local.qbt_host}:${local.qbt_port}"
  remote_path = "/downloads/movies-anime/"
  local_path  = "/downloads/movies-anime/"
}

resource "radarr_naming" "naming_radarrd" {
  provider                   = radarr.radarr_default
  rename_movies              = true
  replace_illegal_characters = true
  colon_replacement_format   = "smart"
  standard_movie_format      = "{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[Mediainfo VideoCodec]}{-Release Group}"
  movie_folder_format        = "{Movie Title} ({Release Year})"
}

resource "radarr_naming" "naming_radarra" {
  provider                   = radarr.radarr_anime
  rename_movies              = true
  replace_illegal_characters = true
  colon_replacement_format   = "smart"
  standard_movie_format      = "{Movie CleanTitle} {(Release Year)} [imdbid-{ImdbId}] - {Edition Tags }{[Custom Formats]}{[Quality Full]}{[MediaInfo 3D]}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{MediaInfo AudioLanguages}[{MediaInfo VideoBitDepth}bit]{[Mediainfo VideoCodec]}{-Release Group}"
  movie_folder_format        = "{Movie Title} ({Release Year})"
}

resource "radarr_media_management" "media_management_radarrd" {
  provider                   = radarr.radarr_default
  create_empty_movie_folders = false
  delete_empty_folders       = true

  skip_free_space_check_when_importing = false
  minimum_free_space_when_importing    = 100
  copy_using_hardlinks                 = true
  import_extra_files                   = true
  extra_file_extensions                = "srt,nfo,sub"

  auto_unmonitor_previously_downloaded_movies = false
  download_propers_and_repacks                = "preferAndUpgrade"
  rescan_after_refresh                        = "always"
  file_date                                   = "none"
  recycle_bin                                 = ""
  recycle_bin_cleanup_days                    = 7

  set_permissions_linux = false
  chmod_folder          = 755
  chown_group           = ""

  auto_rename_folders  = false
  paths_default_static = false
  enable_media_info    = true
}

resource "radarr_media_management" "media_management_radarra" {
  provider                   = radarr.radarr_anime
  create_empty_movie_folders = false
  delete_empty_folders       = true

  skip_free_space_check_when_importing = false
  minimum_free_space_when_importing    = 100
  copy_using_hardlinks                 = true
  import_extra_files                   = true
  extra_file_extensions                = "srt,nfo,sub"

  auto_unmonitor_previously_downloaded_movies = false
  download_propers_and_repacks                = "preferAndUpgrade"
  rescan_after_refresh                        = "always"
  file_date                                   = "none"
  recycle_bin                                 = ""
  recycle_bin_cleanup_days                    = 7

  set_permissions_linux = false
  chmod_folder          = 755
  chown_group           = ""

  auto_rename_folders  = false
  paths_default_static = false
  enable_media_info    = true
}
