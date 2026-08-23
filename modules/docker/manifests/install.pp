class docker::install {
  # 1. Disable IPv6 at Linux Kernel level
  file { '/etc/sysctl.d/99-disable-ipv6.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\n",
  }
  ~> exec { 'apply-sysctl-ipv6':
    command     => '/sbin/sysctl --system',
    refreshonly => true,
  }

  # 2. Native System Resolver Adjustments
  # Forces the glibc system resolver to prioritize IPv4 over IPv6 address records
  file { '/etc/gai.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "precedence ::ffff:0:0/96  100\n",
  }

  # Forces Go runtimes (Docker Compose) to follow system glibc (gai.conf) rules 
  # instead of skipping straight to raw internal IPv6 DNS lookup loops
  file { '/etc/profile.d/disable-ipv6-go.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "export GODEBUG=netdns=cgo\n",
  }

  ## Docker install

  file { '/etc/apt/keyrings':
    ensure => directory,
    mode   => '0755',
  }

  # 3. APT Repository Setup
  exec { 'docker-apt-key':
    command => 'curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc',
    path    => ['/usr/bin', '/bin'],
    creates => '/etc/apt/keyrings/docker.asc',
    require => File['/etc/apt/keyrings'],
  }

  file { '/etc/apt/sources.list.d/docker.list':
    ensure  => file,
    content => "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${facts['os']['distro']['codename']} stable\n",
    require => Exec['docker-apt-key'],
  }
  ~> exec { 'apt-update-docker':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }
  -> package { $docker::packages:
    ensure => installed,
  }

  # 4. User and Group Management
  group { $docker::docker_users:
    ensure => present,
  }

  # Resolves the first user in your array to build the system daemon user
  $primary_docker_user = $docker::docker_users[0]

  user { $primary_docker_user:
    ensure  => present,
    system  => true,
    gid     => $primary_docker_user,
    shell   => '/usr/sbin/nologin',
    home    => '/opt/docker',
    require => Group[$primary_docker_user],
    tag     => 'docker_user',
  }
}
