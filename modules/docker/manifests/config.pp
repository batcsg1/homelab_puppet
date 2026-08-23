class docker::config {
  # 1. Base Directories
  file { '/opt/docker':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/docker':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # 2. Configuration Engine
  file { '/etc/docker/daemon.json':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('docker/daemon.json.epp', {
      'daemon_settings' => $docker::daemon_settings,
    }),
    require => File['/etc/docker'],
  }

  # 3. Containerd Path Override (Ensures extraction happens on /srv)
  file { '/etc/containerd/config.toml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "root = \"/srv/containerd\"\nstate = \"/run/containerd\"\n",
  }

  # 4. Dynamic User Collector Groups
  User <| tag == 'docker_user' |> {
    groups +> $docker::docker_users,
  }
}
