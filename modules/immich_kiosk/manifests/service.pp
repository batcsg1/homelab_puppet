# @summary Brings the compose stack up; refreshes on config change
class immich_kiosk::service {
  $compose = "docker compose -f ${immich_kiosk::base_dir}/compose.yml"
  $path    = ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']

  # Ensure running (covers manual `down`, reboots without restart policy, etc.)
  exec { 'immich-kiosk-ensure-up':
    command => "${compose} up -d --remove-orphans",
    unless  => "${compose} ps --status running -q | grep -q .",
    path    => $path,
  }

  # Pull + recreate when config/compose changes
  exec { 'immich-kiosk-reload':
    command     => "${compose} pull && ${compose} up -d --force-recreate --remove-orphans",
    refreshonly => true,
    path        => $path,
  }
}
