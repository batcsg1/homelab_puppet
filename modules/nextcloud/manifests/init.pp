class nextcloud (
  String  $compose_dir,
  String  $nextcloud_home,
  String  $mysql_password,
  String  $domain_name,
  Optional[String] $cloudflare_tunnel_token,
) {
  contain nextcloud::install
  contain nextcloud::config
  contain nextcloud::service

  Class['nextcloud::install']
  -> Class['nextcloud::config']
  ~> Class['nextcloud::service']
}
