class nextcloud::service {
  exec { 'nextcloud-compose-up':
    command     => '/bin/sh -c "GODEBUG=netdns=cgo docker compose up -d"',
    cwd         => $nextcloud::compose_dir,
    path        => ['/usr/bin', '/bin', '/usr/local/bin'],
    user        => 'docker',
    refreshonly => true,
    subscribe   => [
      File["${nextcloud::compose_dir}/compose.yml"],
      File["${nextcloud::compose_dir}/.env"],
    ],
  }

  exec { 'nextcloud-compose-status':
    command => '/bin/sh -c "GODEBUG=netdns=cgo docker compose up -d"',
    cwd     => $nextcloud::compose_dir,
    path    => ['/usr/bin', '/bin', '/usr/local/bin'],
    user    => 'docker',
    unless  => 'docker compose ps --status running --quiet | grep -q .',
  }
}
