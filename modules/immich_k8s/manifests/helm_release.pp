# @summary Installs/upgrades a Helm release via MicroK8s' bundled helm3
#
# @param chart          Chart path or repo/chart reference
# @param namespace      Target namespace (created if missing)
# @param values_file    Optional values.yaml path
# @param ready_timeout  Seconds to wait for the MicroK8s API before installing
#
# Notify this define (e.g. from the values.yaml File resource) to trigger an upgrade.
#
define microk8s::helm_release (
  String[1]           $chart,
  String[1]           $namespace,
  Optional[String[1]] $values_file   = undef,
  Integer[1]          $ready_timeout = 120,
) {
  $microk8s   = '/snap/bin/microk8s'
  $path       = ['/snap/bin', '/usr/local/bin', '/usr/bin', '/bin']
  $values_arg = $values_file ? {
    undef   => '',
    default => " -f ${values_file}",
  }

  # Block until the API server answers (cold boot / snap restart)
  exec { "microk8s-ready-${name}":
    command => "${microk8s} status --wait-ready --timeout ${ready_timeout}",
    unless  => "${microk8s} status --wait-ready --timeout 5",
    path    => $path,
    timeout => $ready_timeout + 30,
  }

  # First install (skipped once the release exists)
  exec { "helm-install-${name}":
    command => "${microk8s} helm3 upgrade --install ${name} ${chart} -n ${namespace} --create-namespace${values_arg}",
    unless  => "${microk8s} helm3 status ${name} -n ${namespace}",
    path    => $path,
    timeout => 600,
    require => Exec["microk8s-ready-${name}"],
  }

  # Upgrade on refresh (values/chart changed)
  exec { "helm-upgrade-${name}":
    command     => "${microk8s} helm3 upgrade ${name} ${chart} -n ${namespace}${values_arg}",
    refreshonly => true,
    path        => $path,
    timeout     => 600,
    require     => Exec["helm-install-${name}"],
  }
}
