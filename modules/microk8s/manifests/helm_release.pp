# @summary Deploys a Helm chart on MicroK8s with `helm upgrade --install`.
#
# Installs the release if it isn't deployed, and upgrades it when notified
# (e.g. when the chart files or values file change).
#
# @param chart        Path to the chart directory (or repo/chart reference).
# @param namespace    Target namespace (created if missing).
# @param release      Helm release name.
# @param values_file  Optional values file passed with -f.
define microk8s::helm_release (
  String           $chart,
  String           $namespace   = $title,
  String           $release     = $title,
  Optional[String] $values_file = undef,
) {
  $helm     = '/snap/bin/microk8s helm3'
  $vals_arg = $values_file ? {
    undef   => '',
    default => " -f ${values_file}",
  }
  $cmd = "${helm} upgrade --install ${release} ${chart} -n ${namespace} --create-namespace${vals_arg}"

  # First install, or retry after a failed install.
  exec { "helm-install-${release}":
    command     => $cmd,
    unless      => "${helm} status ${release} -n ${namespace} | /bin/grep -q 'STATUS: deployed'",
    environment => ['HOME=/root'],
    timeout     => 900,
    require     => Class['microk8s'],
  }

  # Re-deploy whenever this resource is notified.
  exec { "helm-upgrade-${release}":
    command     => $cmd,
    refreshonly => true,
    environment => ['HOME=/root'],
    timeout     => 900,
    require     => Exec["helm-install-${release}"],
  }
}
