class jellyfin (
  String   $compose_dir,
  String   $jellyfin_home,
  String   $media_location,
  String   $timezone,
  String   $jellyfin_version,
  Integer  $uid,
  Integer  $gid,
  Integer  $http_port,
  Boolean  $hardware_acceleration,
  Optional[String]  $cloudflare_tunnel_token = undef,
) {
  contain jellyfin::install
  contain jellyfin::config
  contain jellyfin::service

  # Enforce application order
  Class['jellyfin::install']
  -> Class['jellyfin::config']
  ~> Class['jellyfin::service']
}
