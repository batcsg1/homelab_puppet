class puppet::server (
  String $certname,
  String $server,
  String $basemodulepath,
  String $runinterval,
  String $dns_alt_names,
  String $vardir,
  String $logdir,
  String $rundir,
  String $codedir,
  Boolean $ca_master = true,
  String  $ca_server = $server,
) {
  # true  => this host runs the CA (CA master)
  # false => CA service disabled, certs come from $ca_server (compile master)
  $ca_service = $ca_master ? {
    true    => 'certificate-authority-service',
    default => 'certificate-authority-disabled-service',
  }

  $ca_line = $ca_service ? {
    true    => 'certificate-authority-service',
    default => 'certificate-authority-disabled-service',
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => file,
    content => epp('puppet/server.conf.epp', {
      'certname'       => $certname,
      'server'         => $server,
      'basemodulepath' => $basemodulepath,
      'runinterval'    => $runinterval,
      'dns_alt_names'  => $dns_alt_names,
      'vardir'         => $vardir,
      'logdir'         => $logdir,
      'rundir'         => $rundir,
      'codedir'        => $codedir,
      'ca_server'      => $ca_master ? { true => undef, default => $ca_server },
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => [Service['puppetserver'], Service['puppet']],
  }

  file { '/etc/puppet/puppetserver/services.d':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755', 
  }

  # CA enabled/disabled is a Puppetserver bootstrap toggle, not a puppet.conf setting.
  file { '/etc/puppet/puppetserver/services.d/ca.cfg':
    ensure  => file,
    content => "puppetlabs.services.ca.${ca_line}/${ca_line}\npuppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/puppet/puppetserver/services.d'],
    notify  => Service['puppetserver'],
  }

  service { 'puppetserver':
    ensure => running,
    enable => true,
  }

  service { 'puppet':
    ensure => running,
    enable => true,
  }
}
