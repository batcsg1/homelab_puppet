# == Class: minecraft::install
#
# Ensures the compose project directory and the server data volume exist.
#
class minecraft::install {

  file { $minecraft::compose_dir:
    ensure => directory,
    owner  => $minecraft::docker_user,
    group  => $minecraft::docker_user,
    mode   => '0755',
  }

  file { $minecraft::server_data:
    ensure => directory,
    owner  => $minecraft::docker_user,
    group  => $minecraft::docker_user,
    mode   => '0755',
  }
}
