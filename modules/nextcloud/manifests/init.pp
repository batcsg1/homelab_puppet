class nextcloud (
  String  $compose_dir       = '/opt/docker/nextcloud',
  String  $nextcloud_home    = '/srv/nextcloud',
  String  $mysql_password    = 'JoinKnight67^&',
  String  $domain_name       = 'cloud.batchelornz.com',
  Optional[String] $cloudflare_tunnel_token = 'eyJhIjoiOGY5N2M3ZDEzYmI5ZGQ0YzQ0MWEyMTJhMWM2NTMxZDUiLCJ0IjoiOWQ0ZDMxYzktMzg5ZS00OWIxLWI1MTktYzg2MzYxNWM1ODRiIiwicyI6Ik5UY3haREpoTnpRdFltTmlOUzAwTnpGbExXSXpZMlV0TkRVNE0ySmtObUkyWTJSbCJ9',
) {
  contain nextcloud::install
  contain nextcloud::config
  contain nextcloud::service

  Class['nextcloud::install']
  -> Class['nextcloud::config']
  ~> Class['nextcloud::service']
}
