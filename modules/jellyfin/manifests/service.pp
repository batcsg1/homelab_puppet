class jellyfin::service {
  exec { 'jellyfin-compose-up':
    command     => 'docker compose up -d',
    cwd         => $jellyfin::compose_dir,
    path        => ['/usr/bin', '/bin', '/usr/local/bin'],
    user        => 'docker',
    refreshonly => true,
    timeout     => 1200,
    subscribe   => [
      File["${jellyfin::compose_dir}/compose.yml"],
      File["${jellyfin::compose_dir}/.env"],
    ],
  }

  exec { 'jellyfin-compose-status':
    command => 'docker compose up -d',
    cwd     => $jellyfin::compose_dir,
    path    => ['/usr/bin', '/bin', '/usr/local/bin'],
    user    => 'docker',
    unless  => 'docker compose ps --status running --quiet | grep -q .',
  }
}
