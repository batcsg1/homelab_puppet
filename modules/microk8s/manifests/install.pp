# @summary Installs snapd and the MicroK8s snap, then waits for it to be ready.
class microk8s::install {
  $channel_arg = $microk8s::channel ? {
    undef   => '',
    default => " --channel=${microk8s::channel}",
  }

  package { 'snapd':
    ensure => installed,
  }

  exec { 'install-microk8s':
    command => "/usr/bin/snap install microk8s --classic${channel_arg}",
    unless  => '/usr/bin/snap list microk8s',
    timeout => 900,
    require => Package['snapd'],
  }

  exec { 'microk8s-wait-ready':
    command => '/snap/bin/microk8s status --wait-ready',
    unless  => "/snap/bin/microk8s status | /bin/grep -q 'is running'",
    timeout => 600,
    require => Exec['install-microk8s'],
  }
}
