class docker::service {
  # 1. Native Service Definitions
  service { 'containerd':
    ensure => $docker::service_ensure,
    enable => $docker::service_enable,
  }

  service { 'docker':
    ensure  => $docker::service_ensure,
    enable  => $docker::service_enable,
    require => Service['containerd'],
  }

  # 2. Systemd Daemon Environment Override
  # Forces the background Docker process to respect system IPv4 preferences 
  file { '/etc/systemd/system/docker.service.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/systemd/system/docker.service.d/override.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "[Service]\nEnvironment=\"GODEBUG=netdns=cgo\"\n",
    require => File['/etc/systemd/system/docker.service.d'],
    notify  => Exec['docker-systemd-reload'],
  }

  exec { 'docker-systemd-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
    notify      => Exec['restart-docker-daemon'],
  }

  # 3. Automated Service Restarts (Triggered via ~> notifications)
  exec { 'restart-containerd':
    command     => '/bin/systemctl restart containerd',
    refreshonly => true,
    before      => Exec['restart-docker-daemon'],
    notify      => Service['containerd'],
  }

  exec { 'restart-docker-daemon':
    command     => '/bin/systemctl restart docker',
    refreshonly => true,
    notify      => Service['docker'],
  }

  exec { 'wait-for-docker-ready':
    command     => '/bin/sh -c "for i in \$(seq 1 15); do docker info >/dev/null 2>&1 && exit 0; sleep 1; done; exit 1"',
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    require     => Exec['restart-docker-daemon'],
  }
}
