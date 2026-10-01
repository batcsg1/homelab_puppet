# == Class: minecraft
#
# Deploys the "Snowdon" Minecraft server as a Docker Compose stack on
# BAT-DEB-PC01. Mirrors the install/config/service layout used by the
# nextcloud and immich modules. All parameters are looked up from Hiera
# via automatic parameter lookup — see data/common.yaml.
#
class minecraft (
  String  $compose_dir,
  String  $server_data,
  String  $image,
  String  $container_name,
  String  $level,
  String  $mode,
  Boolean $eula,
  Integer $game_port,
  Integer $dynmap_port,
  String  $restart_policy,
  Integer $bluemap_port,
  Array[String] $modrinth_projects,
  String  $docker_user,
  String           $server_type   = 'PAPER',
  Optional[String] $custom_server = undef,
) {

  contain minecraft::install
  contain minecraft::config
  contain minecraft::service

  Class['minecraft::install']
  -> Class['minecraft::config']
  -> Class['minecraft::service']
}
