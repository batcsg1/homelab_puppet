# @summary Enables MicroK8s addons (not on workers) and grants users access.
class microk8s::config {
  $mk8s = '/snap/bin/microk8s'

  if $microk8s::gpu {
  file { '/etc/microk8s':
    ensure => directory,
  }
    file { $microk8s::gpu_values:
      ensure  => file,
      mode    => '0644',
      content => @(YAML),
        # Managed by Puppet (microk8s). GPU Operator settings for Debian + host driver/toolkit.
        toolkit:
          enabled: false
        operator:
          runtimeClass: nvidia-container-runtime
          defaultRuntime: containerd
        validator:
          cuda:
            env:
              - name: WITH_WORKLOAD
                value: "false"
        | YAML
      before  => Exec['microk8s-enable-nvidia'],
    }
  }

  if $microk8s::role != 'worker' {
    $microk8s::all_addons.each |$addon, $args| {
      $arg_str = $args ? {
        ''      => '',
        default => " ${args}",
      }

      exec { "microk8s-enable-${addon}":
        command => "${mk8s} enable ${addon}${arg_str}",
        unless  => "${mk8s} status -a ${addon} | /bin/grep -q enabled",
        timeout => 900,
      }
    }
  }

  $microk8s::users.each |$user| {
    exec { "microk8s-group-${user}":
      command => "/usr/sbin/usermod -aG microk8s ${user}",
      unless  => "/usr/bin/id -nG ${user} | /bin/grep -qw microk8s",
    }
  }
}
