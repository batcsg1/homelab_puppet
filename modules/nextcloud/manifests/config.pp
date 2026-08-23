class nextcloud::config {
  file { "${nextcloud::compose_dir}/compose.yml":
    ensure  => file,
    owner   => 'docker',
    group   => 'docker',
    mode    => '0640',
    content => epp('nextcloud/compose.yml.epp'),
    require => File[$nextcloud::compose_dir],
  }

  file { "${nextcloud::compose_dir}/.env":
    ensure    => file,
    owner     => 'docker',
    group     => 'docker',
    mode      => '0600',
    content   => template('nextcloud/env.erb'),
    require   => File[$nextcloud::compose_dir],
    show_diff => false,
  }
}
