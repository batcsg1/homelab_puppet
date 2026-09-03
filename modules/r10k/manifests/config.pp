class r10k::config {
  file { '/etc/puppet/r10k':
    ensure => directory,
  }

  file { '/etc/puppet/r10k/r10k.yaml':
    ensure  => file,
    content => epp('r10k/r10k.yaml.epp', {
      'remote'   => $r10k::remote,
      'basedir'  => $r10k::basedir,
      'cachedir' => $r10k::cachedir,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/puppet/r10k'],
  }

  file { '/var/cache/r10k':
    ensure => directory,
  }
}
