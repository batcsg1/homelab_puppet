# == Class: minecraft::config
#
# Renders compose.yml and .env for the mc-snowdon stack. No Cloudflare
# tunnel service or token — this stack is compose-only.
#
class minecraft::config {

  file { "${minecraft::compose_dir}/compose.yml":
    ensure  => file,
    owner   => $minecraft::docker_user,
    group   => $minecraft::docker_user,
    mode    => '0644',
    content => epp('minecraft/compose.yml.epp', {
      'image'             => $minecraft::image,
      'container_name'    => $minecraft::container_name,
      'eula'              => $minecraft::eula,
      'level'             => $minecraft::level,
      'mode'              => $minecraft::mode,
      'game_port'         => $minecraft::game_port,
      'dynmap_port'       => $minecraft::dynmap_port,
      'bluemap_port'      => $minecraft::bluemap_port,
      'modrinth_projects' => $minecraft::modrinth_projects,
      'restart_policy'    => $minecraft::restart_policy,
      'server_type'   => $minecraft::server_type,
      'custom_server' => $minecraft::custom_server,
    }),
    require => File[$minecraft::compose_dir],
  }

  file { "${minecraft::compose_dir}/.env":
    ensure  => file,
    owner   => $minecraft::docker_user,
    group   => $minecraft::docker_user,
    mode    => '0600',
    content => epp('minecraft/env.epp', {
      'server_data' => $minecraft::server_data,
    }),
    require => File[$minecraft::compose_dir],
  }

  # BlueMap generates core.conf on first start with accept-download: false.
  # Flip it once the file exists; compose up -d won't restart an unchanged
  # container, so trigger an explicit restart.
  exec { 'bluemap-accept-download':
    command => "sed -i 's/^accept-download: false/accept-download: true/' ${minecraft::server_data}/plugins/BlueMap/core.conf",
    onlyif  => "grep -q '^accept-download: false' ${minecraft::server_data}/plugins/BlueMap/core.conf",
    path    => ['/usr/bin', '/bin'],
    notify  => Exec['minecraft-restart'],
  }
}
