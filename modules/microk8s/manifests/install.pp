# @summary Installs snapd, MicroK8s and host dependencies, then ensures it is running and ready.
class microk8s::install {
  $channel_arg = $microk8s::channel ? {
    undef   => '',
    default => " --channel=${microk8s::channel}",
  }

  package { ['snapd', 'nfs-common']:
    ensure => installed,
  }

  # GPU nodes use the host's NVIDIA container toolkit (the operator's bundled
  # toolkit can't handle Debian's /etc/alternatives driver layout).
  # Requires NVIDIA's libnvidia-container apt repo to be configured.
  if $microk8s::gpu {
    package { 'nvidia-container-toolkit':
      ensure => installed,
      before => Exec['install-microk8s'],
    }
  }

  exec { 'install-microk8s':
    command => "/usr/bin/snap install microk8s --classic${channel_arg}",
    unless  => '/usr/bin/snap list microk8s',
    timeout => 900,
    require => Package['snapd'],
  }

  # Start if stopped, then block until the API is ready.
  # Skipped entirely when already running.
  exec { 'microk8s-wait-ready':
    command => '/snap/bin/microk8s start && /snap/bin/microk8s status --wait-ready --timeout 300',
    unless  => "/snap/bin/microk8s status | /bin/grep -q 'is running'",
    timeout => 600,
    require => Exec['install-microk8s'],
  }
}
