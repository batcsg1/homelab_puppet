class immich::service {
  exec { 'immich-compose-up':
    command     => 'docker compose up -d',
    cwd         => $immich::compose_dir,
    path        => ['/usr/bin', '/bin', '/usr/local/bin'],
    user        => 'docker',
    refreshonly => true,
    timeout     => 1200,
    subscribe   => [
      File["${immich::compose_dir}/compose.yml"],
      File["${immich::compose_dir}/.env"],
    ],
  }

  exec { 'immich-compose-status':
    command => 'docker compose up -d',
    cwd     => $immich::compose_dir,
    path    => ['/usr/bin', '/bin', '/usr/local/bin'],
    user    => 'docker',
    unless  => 'docker compose ps --status running --quiet | grep -q .',
  }
}
