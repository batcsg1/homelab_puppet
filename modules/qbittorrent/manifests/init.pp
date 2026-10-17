# @summary Installs qbittorrent-nox as a systemd service with the WebUI enabled.
#
# @param user          Service account that runs qBittorrent.
# @param download_dir  Download directory (bind mount from the Proxmox host).
# @param webui_port    WebUI listen port.
#
# @example
#   include qbittorrent
#
class qbittorrent (
  String               $user         = 'qbt',
  String               $download_dir = '/downloads',
  String               $webui_port   = 8080,
) {
  package { 'qbittorrent-nox':
    ensure => installed,
  }

  user { $user:
    ensure     => present,
    system     => true,
    managehome => true,
    home       => "/home/${user}",
    shell      => '/usr/sbin/nologin',
  }

  file { $download_dir:
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => User[$user],
  }

  file { '/etc/systemd/system/qbittorrent.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('qbittorrent/qbittorrent.service.epp', {
      'user'       => $user,
      'webui_port' => $webui_port,
    }),
  }

  # Puppet 6.1+ reloads systemd automatically when a unit file changes.
  service { 'qbittorrent':
    ensure    => running,
    enable    => true,
    require   => [Package['qbittorrent-nox'], File[$download_dir]],
    subscribe => File['/etc/systemd/system/qbittorrent.service'],
  }
}
