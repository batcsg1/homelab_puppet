class pxe (
  String $interface, 
  String $subnet,
  String $tftp_root,
  String $efi_url,
) {
  contain pxe::install
  contain pxe::config
  contain pxe::service

  Class['pxe::install'] -> Class['pxe::config'] ~> Class['pxe::service']
}
