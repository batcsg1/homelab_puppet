class nextcloud::install {
  file { $nextcloud::compose_dir:
    ensure => directory,
    owner  => 'docker',
    group  => 'docker',
    mode   => '0750',
    require => File['/opt/docker'],
  }
  file { $nextcloud::nextcloud_home:
    ensure => directory,
    owner  => 'docker',
    group  => 'docker',
    mode   => '0750',
  }
  file { [
    "${nextcloud::nextcloud_home}/data",
    "${nextcloud::nextcloud_home}/www",
  ]:
    ensure  => directory,
    owner   => 33,
    group   => 33,
    mode    => '0750',
    require => File[$nextcloud::nextcloud_home],
  }

  file { "${nextcloud::nextcloud_home}/db":
    ensure  => directory,
    owner   => 999,
    group   => 999,
    mode    => '0750',
    require => File[$nextcloud::nextcloud_home],
  }
}
