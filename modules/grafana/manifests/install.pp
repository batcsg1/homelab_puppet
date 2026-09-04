class grafana::install {

  # Ensure required directories exist
  file { '/etc/apt/keyrings':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Install GPG key (no wget dependency issues)
  exec { 'grafana_key':
    command => '/usr/bin/curl -fsSL https://apt.grafana.com/gpg.key | /usr/bin/gpg --dearmor -o /etc/apt/keyrings/grafana.gpg',
    creates => '/etc/apt/keyrings/grafana.gpg',
    path    => ['/usr/bin', '/bin'],
    require => File['/etc/apt/keyrings'],
  }

  # Add Grafana repository
  file { '/etc/apt/sources.list.d/grafana.list':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main',
    require => Exec['grafana_key'],
    notify  => Exec['apt_update'],
  }

  # Update APT cache when repo changes
  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    path        => ['/usr/bin', '/bin'],
  }

  # Install Grafana
  package { 'grafana':
    ensure  => installed,
    require => Exec['apt_update'],
  }

}
