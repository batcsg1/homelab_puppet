# @summary Enables MicroK8s addons and grants users access.
class microk8s::config {
  $mk8s = '/snap/bin/microk8s'

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

  $microk8s::users.each |$user| {
    exec { "microk8s-group-${user}":
      command => "/usr/sbin/usermod -aG microk8s ${user}",
      unless  => "/usr/bin/id -nG ${user} | /bin/grep -qw microk8s",
    }
  }
}
