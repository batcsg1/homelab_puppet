class pxe::config {
  file { $pxe::tftp_root:
    ensure => directory,
    owner  => 'dnsmasq',
    mode   => '0755',
  }

  file { "${pxe::tftp_root}/netboot.xyz.efi":
    ensure  => file,
    source  => $pxe::efi_url,
    replace => false,   # don't re-download every run
    mode    => '0644',
  }

  file { '/etc/dnsmasq.d/pxe.conf':
    ensure  => file,
    content => epp('pxe/pxe.conf.epp'),
    mode    => '0644',
  }
}
