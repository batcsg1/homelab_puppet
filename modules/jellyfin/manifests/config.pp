class jellyfin::config {
  file { "${jellyfin::compose_dir}/compose.yml":
    ensure  => file,
    owner   => 'docker',
    group   => 'docker',
    mode    => '0640',
    content => epp('jellyfin/compose.yml.epp'),
    require => File[$jellyfin::compose_dir],
  }

  file { "${jellyfin::compose_dir}/.env":
    ensure  => file,
    owner   => 'docker',
    group   => 'docker',
    mode    => '0600',
    content => template('jellyfin/env.erb'),
    require => File[$jellyfin::compose_dir],
  }
}
