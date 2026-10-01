# @summary Deploys immich-kiosk via Docker Compose
#
# @param immich_url      URL kiosk uses to reach Immich (container name if on same docker network)
# @param immich_api_key  Immich API key (keep in eyaml)
# @param image_tag       Image tag; pin a version for reproducible deploys
# @param base_dir        Compose project directory
# @param port            Host port published for kiosk
# @param timezone        Container TZ
# @param lang            Container LANG (date/time formatting)
# @param network         Optional external docker network to join (e.g. Immich's)
# @param settings        Extra config.yaml keys merged over defaults
#
class immich_kiosk (
  Pattern[/^https?:\/\//]            $immich_url,
  Sensitive[String[1]]       $immich_api_key,
  String[1]                  $image_tag = 'latest',
  Pattern[/^\//]       $base_dir  = '/opt/docker/immich-kiosk',
  Integer[1, 65535]               $port      = 3000,
  String[1]                  $timezone  = 'Pacific/Auckland',
  String[1]                  $lang      = 'en_NZ',
  Optional[String[1]]        $network   = undef,
  Hash[String, Data]         $settings  = {},
) {
  contain immich_kiosk::install
  contain immich_kiosk::config
  contain immich_kiosk::service

  Class['immich_kiosk::install']
  -> Class['immich_kiosk::config']
  ~> Class['immich_kiosk::service']
}
