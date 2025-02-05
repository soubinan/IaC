provider "sonarr" {
  alias   = "sonarr_default"
  url     = local.sonarr_default_endpoint
  api_key = var.starr_api_key
}

provider "sonarr" {
  alias   = "sonarr_anime"
  url     = local.sonarr_anime_endpoint
  api_key = var.starr_api_key
}

resource "sonarr_download_client_qbittorrent" "torrent_sonarrd" {
  provider       = sonarr.sonarr_default
  enable         = true
  priority       = 1
  name           = "qBittorrent"
  host           = local.qbt_host
  port           = local.qbt_port
  tv_category    = "sonarr-default"
  first_and_last = true
  username       = var.qbt_usr
  password       = var.qbt_pwd
}

resource "sonarr_download_client_qbittorrent" "torrent_sonarra" {
  provider       = sonarr.sonarr_anime
  enable         = true
  priority       = 1
  name           = "qBittorrent"
  host           = local.qbt_host
  port           = local.qbt_port
  tv_category    = "sonarr-anime"
  first_and_last = true
  username       = var.qbt_usr
  password       = var.qbt_pwd
}

resource "sonarr_root_folder" "path_sonarrd" {
  provider = sonarr.sonarr_default
  path     = "/mnt/media/shows"
}

resource "sonarr_root_folder" "path_sonarra" {
  provider = sonarr.sonarr_anime
  path     = "/mnt/media/shows-anime"
}

resource "sonarr_naming" "naming_sonarrd" {
  provider                   = sonarr.sonarr_default
  rename_episodes            = true
  replace_illegal_characters = true
  multi_episode_style        = 0
  colon_replacement_format   = 4
  series_folder_format       = "{Series TitleYear} [tvdbid-{TvdbId}]"
  season_folder_format       = "Season {season:00}"
  specials_folder_format     = "Specials"
  standard_episode_format    = "{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}"
  daily_episode_format       = "{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}"
  anime_episode_format       = "{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}"
}

resource "sonarr_naming" "naming_sonarra" {
  provider                   = sonarr.sonarr_anime
  rename_episodes            = true
  replace_illegal_characters = true
  multi_episode_style        = 0
  colon_replacement_format   = 4
  series_folder_format       = "{Series TitleYear} [tvdbid-{TvdbId}]"
  season_folder_format       = "Season {season:00}"
  specials_folder_format     = "Specials"
  standard_episode_format    = "{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}"
  daily_episode_format       = "{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}"
  anime_episode_format       = "{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}"
}

resource "sonarr_media_management" "media_management_sonarrd" {
  provider             = sonarr.sonarr_default
  create_empty_folders = false
  delete_empty_folders = true

  episode_title_required = "always"
  skip_free_space_check  = false
  minimum_free_space     = 100
  hardlinks_copy         = true
  import_extra_files     = true
  extra_file_extensions  = "srt,nfo,sub"

  unmonitor_previous_episodes = false
  download_propers_repacks    = "preferAndUpgrade"
  rescan_after_refresh        = "always"
  file_date                   = "none"
  recycle_bin_path            = ""
  recycle_bin_days            = 7

  set_permissions = false
  chmod_folder    = 755
  chown_group     = ""

  enable_media_info = true
}

resource "sonarr_media_management" "media_management_sonarra" {
  provider             = sonarr.sonarr_anime
  create_empty_folders = false
  delete_empty_folders = true

  episode_title_required = "always"
  skip_free_space_check  = false
  minimum_free_space     = 100
  hardlinks_copy         = true
  import_extra_files     = true
  extra_file_extensions  = "srt,nfo,sub"

  unmonitor_previous_episodes = false
  download_propers_repacks    = "preferAndUpgrade"
  rescan_after_refresh        = "always"
  file_date                   = "none"
  recycle_bin_path            = ""
  recycle_bin_days            = 7

  set_permissions = false
  chmod_folder    = 755
  chown_group     = ""

  enable_media_info = true
}
