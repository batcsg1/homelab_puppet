class immich::install {
  file { $immich::compose_dir:
    ensure => directory,
    owner  => 'docker',
    group  => 'docker',
    mode   => '0750',
  }

  file { $immich::immich_location:
    ensure => directory,
    owner  => 'docker',
    group  => 'docker',
    mode   => '0750',
  }

  file { "${immich::immich_location}/data":
    ensure  => directory,
    owner   => 'docker',
    group   => 'docker',
    mode    => '0750',
    require => File[$immich::immich_location],
  }

  # Postgres container runs internally as UID 999 — its data directory
  # must be owned by that UID, not the host's docker user
  file { "${immich::immich_location}/db":
    ensure  => directory,
    owner   => '999',
    group   => '999',
    mode    => '0700',
    require => File[$immich::immich_location],
  }

}
