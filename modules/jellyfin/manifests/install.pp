class jellyfin::install {
  file { $jellyfin::compose_dir:
    ensure  => directory,
    owner   => 'docker',
    group   => 'docker',
    mode    => '0750',
    require => File['/opt/docker'],
  }

  file { $jellyfin::jellyfin_home:
    ensure => directory,
    owner  => 'docker',
    group  => 'docker',
    mode   => '0750',
  }

  # Jellyfin container runs as $uid:$gid — its config and cache
  # directories must be owned by that UID, not the host's docker user
  file { [
    "${jellyfin::jellyfin_home}/config",
    "${jellyfin::jellyfin_home}/cache",
  ]:
    ensure  => directory,
    owner   => $jellyfin::uid,
    group   => $jellyfin::gid,
    mode    => '0750',
    require => File[$jellyfin::jellyfin_home],
  }

  # Only ensure the media directory exists; ownership of existing
  # media libraries is left alone
  file { $jellyfin::media_location:
    ensure => directory,
  }
}
