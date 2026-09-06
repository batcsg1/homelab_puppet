class puppet::agent (
  String $server,
  String $runinterval,
  String $dns_alt_names = undef,
  String $certname            = $facts['networking']['fqdn'],
  Optional[String] $ca_server = undef,
) {
  file { '/etc/puppet/puppet.conf':
    ensure  => file,
    content => epp('puppet/agent.conf.epp', {
      'certname'      => $certname,
      'server'        => $server,
      'ca_server'     => $ca_server,
      'runinterval'   => $runinterval,
      'dns_alt_names' => $dns_alt_names,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['puppet'],
  }

  service { 'puppet':
    ensure => running,
    enable => true,
  }
}
