class immich (
  String            $compose_dir,
  String            $immich_location,
  String            $timezone,
  String            $db_username,
  String            $db_password,
  String            $db_database_name,
  Optional[String]  $cloudflare_tunnel_token = undef,
  String            $immich_version,
) {
  contain immich::install
  contain immich::config
  contain immich::service

  # Enforce application order
  Class['immich::install']
  -> Class['immich::config']
  ~> Class['immich::service']
}
