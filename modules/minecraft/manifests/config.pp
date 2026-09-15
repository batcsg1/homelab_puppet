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
      'image'          => $minecraft::image,
      'container_name' => $minecraft::container_name,
      'eula'           => $minecraft::eula,
      'level'          => $minecraft::level,
      'mode'           => $minecraft::mode,
      'game_port'      => $minecraft::game_port,
      'dynmap_port'    => $minecraft::dynmap_port,
      'restart_policy' => $minecraft::restart_policy,
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
}
