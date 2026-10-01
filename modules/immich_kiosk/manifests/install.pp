# @summary Creates the compose project layout
class immich_kiosk::install {
  file { [$immich_kiosk::base_dir, "${immich_kiosk::base_dir}/config"]:
    ensure => directory,
    owner  => 'root',
    group  => 'docker',
    mode   => '0750',
  }
}
