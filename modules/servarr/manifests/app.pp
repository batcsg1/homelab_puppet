# @summary Installs one *arr app (Radarr, Prowlarr, Sonarr, ...) from the official
#   Servarr tarball and runs it as a systemd service.
#
# @param app         Directory/binary name as shipped in the tarball (e.g. 'Radarr').
# @param user        Service account (shares with qBittorrent so file ownership matches).
# @param group       Service group.
# @param branch      Update branch to download from.
# @param install_dir Parent directory for the extracted app.
#
# @example
#   servarr::app { 'radarr': app => 'Radarr' }
#
define servarr::app (
  String               $app,
  String               $user        = $servarr::user,
  String               $group       = $servarr::group,
  String               $branch      = $servarr::branch,
  Pattern[/^\//]     $install_dir = $servarr::install_dir,
) {
  $lc       = downcase($app)
  $url      = "https://${lc}.servarr.com/v1/update/${branch}/updatefile?os=linux&runtime=netcore&arch=x64"
  $tarball  = "/tmp/${lc}.tar.gz"
  $data_dir = "/var/lib/${lc}"

  file { $data_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  # Download and extract once; the app self-updates afterwards.
  exec { "servarr-install-${lc}":
    command => "curl -fsSL -o ${tarball} '${url}' && tar -xzf ${tarball} -C ${install_dir} && rm -f ${tarball}",
    path    => ['/usr/bin', '/bin'],
    creates => "${install_dir}/${app}/${app}",
    timeout => 600,
    require => Package['curl'],
  }

  exec { "servarr-chown-${lc}":
    command     => "chown -R ${user}:${group} ${install_dir}/${app}",
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => Exec["servarr-install-${lc}"],
  }

  file { "/etc/systemd/system/${lc}.service":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('servarr/app.service.epp', {
      'app'         => $app,
      'lc'          => $lc,
      'user'        => $user,
      'group'       => $group,
      'install_dir' => $install_dir,
      'data_dir'    => $data_dir,
    }),
  }

  service { $lc:
    ensure    => running,
    enable    => true,
    require   => [Exec["servarr-chown-${lc}"], File[$data_dir]],
    subscribe => File["/etc/systemd/system/${lc}.service"],
  }
}
