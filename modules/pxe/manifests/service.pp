class pxe::service {
  service { 'dnsmasq':
    ensure => running,
    enable => true,
  }
}
