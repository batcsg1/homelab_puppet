class immich::config {
  file { "${immich::compose_dir}/compose.yml":
    ensure  => file,
    owner   => 'docker',
    group   => 'docker',
    mode    => '0640',
    content => epp('immich/compose.yml.epp'),
    require => File[$immich::compose_dir],
  }

  file { "${immich::compose_dir}/.env":
    ensure    => file,
    owner     => 'docker',
    group     => 'docker',
    mode      => '0600',
    content   => template('immich/env.erb'),
    require   => File[$immich::compose_dir],
    show_diff => false,
  }
}
