# @summary Renders compose.yml and kiosk config.yaml
class immich_kiosk::config {
  $base_config = {
    'immich_url'     => $immich_kiosk::immich_url,
    'immich_api_key' => $immich_kiosk::immich_api_key.unwrap,
  }

  file { "${immich_kiosk::base_dir}/compose.yml":
    ensure  => file,
    owner   => 'root',
    group   => 'docker',
    mode    => '0640',
    content => epp('immich_kiosk/compose.yml.epp', {
      'image_tag' => $immich_kiosk::image_tag,
      'port'      => $immich_kiosk::port,
      'timezone'  => $immich_kiosk::timezone,
      'lang'      => $immich_kiosk::lang,
      'network'   => $immich_kiosk::network,
    }),
  }

  file { "${immich_kiosk::base_dir}/config/config.yaml":
    ensure    => file,
    owner     => 'root',
    group     => 'docker',
    mode      => '0640',
    show_diff => false,
    content   => Sensitive(epp('immich_kiosk/config.yaml.epp', {
      'config' => $base_config + $immich_kiosk::settings,
    })),
  }
}
