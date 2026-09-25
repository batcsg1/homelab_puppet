# @summary Installs and configures MicroK8s (snap), addons and user access.
#
# @param channel  Optional snap channel, e.g. '1.33/stable'. Defaults to snap's default.
# @param addons   Addons to enable, name => extra args ('' for none).
# @param gpu      Adds the nvidia addon, using the host's existing NVIDIA driver.
# @param users    Users added to the microk8s group.
class microk8s (
  Optional[String]     $channel = undef,
  Hash[String, String] $addons  = {
    'dns'              => '',
    'hostpath-storage' => '',
    'helm3'            => '',
  },
  Boolean              $gpu     = false,
  Array[String]        $users   = [],
) {
  $all_addons = $gpu ? {
    true    => $addons + { 'nvidia' => '--gpu-operator-driver host' },
    default => $addons,
  }

  contain microk8s::install
  contain microk8s::config

  Class['microk8s::install'] -> Class['microk8s::config']
}
