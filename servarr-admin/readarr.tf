provider "readarr" {
  alias   = "readarr_default"
  url     = local.readarr_default_endpoint
  api_key = var.starr_api_key
}

provider "readarr" {
  alias   = "readarr_anime"
  url     = local.readarr_anime_endpoint
  api_key = var.starr_api_key
}

resource "readarr_download_client_qbittorrent" "torrent_readarrd" {
  provider       = readarr.readarr_default
  enable         = true
  priority       = 1
  name           = "qBittorrent"
  host           = local.qbt_host
  port           = local.qbt_port
  book_category  = "readarr-default"
  first_and_last = true
  username       = var.qbt_usr
  password       = var.qbt_pwd
}

resource "readarr_download_client_qbittorrent" "torrent_readarra" {
  provider       = readarr.readarr_anime
  enable         = true
  priority       = 1
  name           = "qBittorrent"
  host           = local.qbt_host
  port           = local.qbt_port
  book_category  = "readarr-anime"
  first_and_last = true
  username       = var.qbt_usr
  password       = var.qbt_pwd
}

resource "readarr_root_folder" "path_books_readarrd" {
  provider                        = readarr.readarr_default
  name                            = "root_path_books"
  path                            = "/mnt/media/books"
  default_metadata_profile_id     = 1
  default_quality_profile_id      = 1
  default_monitor_new_item_option = "all"
  default_monitor_option          = "all"
  is_calibre_library              = false
  output_profile                  = "default"
}

resource "readarr_root_folder" "path_books_readarra" {
  provider                        = readarr.readarr_anime
  name                            = "root_path_books"
  path                            = "/mnt/media/books-anime"
  default_metadata_profile_id     = 1
  default_quality_profile_id      = 1
  default_monitor_new_item_option = "all"
  default_monitor_option          = "all"
  is_calibre_library              = false
  output_profile                  = "default"
}

resource "readarr_root_folder" "path_audio_readarrd" {
  provider                        = readarr.readarr_default
  name                            = "root_path_audio"
  path                            = "/mnt/media/books/audio"
  default_metadata_profile_id     = 1
  default_quality_profile_id      = 2
  default_monitor_new_item_option = "all"
  default_monitor_option          = "all"
  is_calibre_library              = false
  output_profile                  = "default"
}

resource "readarr_root_folder" "path_audio_readarra" {
  provider                        = readarr.readarr_anime
  name                            = "root_path_audio"
  path                            = "/mnt/media/books-anime/audio"
  default_metadata_profile_id     = 1
  default_quality_profile_id      = 2
  default_monitor_new_item_option = "all"
  default_monitor_option          = "all"
  is_calibre_library              = false
  output_profile                  = "default"
}

resource "readarr_naming" "naming_readarrd" {
  provider                   = readarr.readarr_default
  rename_books               = true
  replace_illegal_characters = true
  colon_replacement_format   = 4
  author_folder_format       = "{Author Name}"
  standard_book_format       = "{Book Title}/{Author Name} - {Book Title} {(PartNumber)}"
}

resource "readarr_naming" "naming_readarra" {
  provider                   = readarr.readarr_anime
  rename_books               = true
  replace_illegal_characters = true
  colon_replacement_format   = 4
  author_folder_format       = "{Author Name}"
  standard_book_format       = "{Book Title}/{Author Name} - {Book Title} {(PartNumber)}"
}

resource "readarr_media_management" "media_management_readarrd" {
  provider                    = readarr.readarr_default
  unmonitor_previous_books    = false
  hardlinks_copy              = true
  create_empty_author_folders = false
  delete_empty_folders        = true
  watch_ibrary_for_changes    = true
  import_extra_files          = true
  set_permissions             = false
  skip_free_space_check       = false
  minimum_free_space          = 100
  recycle_bin_days            = 7
  chmod_folder                = 755
  chown_group                 = ""
  download_propers_repacks    = "preferAndUpgrade"
  allow_fingerprinting        = "never"
  extra_file_extensions       = "info,nfo"
  file_date                   = "none"
  recycle_bin_path            = ""
  rescan_after_refresh        = "always"
}

resource "readarr_media_management" "media_management_readarra" {
  provider                    = readarr.readarr_anime
  unmonitor_previous_books    = false
  hardlinks_copy              = true
  create_empty_author_folders = false
  delete_empty_folders        = true
  watch_ibrary_for_changes    = true
  import_extra_files          = true
  set_permissions             = false
  skip_free_space_check       = false
  minimum_free_space          = 100
  recycle_bin_days            = 7
  chmod_folder                = 755
  chown_group                 = ""
  download_propers_repacks    = "preferAndUpgrade"
  allow_fingerprinting        = "never"
  extra_file_extensions       = "info,nfo"
  file_date                   = "none"
  recycle_bin_path            = ""
  rescan_after_refresh        = "always"
}
