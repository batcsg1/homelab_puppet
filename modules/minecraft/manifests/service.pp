# == Class: minecraft::service
#
# Brings the compose stack up, re-running only when the rendered
# compose.yml or .env change.
#
class minecraft::service {

  exec { 'minecraft-compose-up':
    command     => 'docker compose up -d',
    cwd         => $minecraft::compose_dir,
    path        => ['/usr/bin', '/usr/local/bin', '/bin'],
    user        => $minecraft::docker_user,
    subscribe   => [
      File["${minecraft::compose_dir}/compose.yml"],
      File["${minecraft::compose_dir}/.env"],
    ],
    refreshonly => true,
  }
}
