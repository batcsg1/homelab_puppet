# @summary Installs Servarr apps (Prowlarr, Radarr, Sonarr, ...) as systemd services.
#
# @param apps        Hash of resource title => { app => 'Name' }.
# @param user        Service account; use the qBittorrent user so imports keep ownership.
# @param group       Service group.
# @param branch      Servarr update branch.
# @param install_dir Where apps are extracted.
# @param media_dirs  Media directories (LXC bind mounts) the apps must write to.
# @param icu_package libicu package name for the Debian release.
#
# @example
#   include servarr
#
# @example Add Sonarr too
#   class { 'servarr':
#     apps => {
#       'prowlarr' => { 'app' => 'Prowlarr' },
#       'radarr'   => { 'app' => 'Radarr' },
#       'sonarr'   => { 'app' => 'Sonarr' },
#     },
#     media_dirs => ['/movies', '/tv'],
#   }
#
class servarr (
  Hash                       $apps        = {
    'prowlarr' => { 'app' => 'Prowlarr' },
    'radarr'   => { 'app' => 'Radarr' },
  },
  String                     $user        = 'qbt',
  String                     $group       = 'qbt',
  String                     $branch      = 'master',
  Pattern[/^\//]           $install_dir = '/opt',
  Array[Pattern[/^\//]]  $media_dirs = ['/movies'],
  String                     $icu_package = $facts['os']['release']['major'] ? {
    '12'    => 'libicu72',
    default => 'libicu76',
  },
) {
  package { ['curl', 'sqlite3', $icu_package]:
    ensure => installed,
  }

  file { $media_dirs:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  $apps.each |String $title, Hash $params| {
    servarr::app { $title:
      *       => $params,
      require => [User[$user], File[$media_dirs]],
    }
  }
}
