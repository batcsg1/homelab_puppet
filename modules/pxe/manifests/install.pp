class pxe::install {
  package { 'dnsmasq': ensure => installed }
}
