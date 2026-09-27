# @summary Installs and configures MicroK8s (snap), addons, users and cluster membership.
#
# Defaults live in the module's data/common.yaml; override them in environment Hiera.
class microk8s (
  Enum['standalone', 'control', 'worker'] $role,
  Hash[String, String]                    $addons,
  Boolean                                 $gpu,
  Array[String]                           $users,
  Optional[Sensitive[String[32, 32]]]     $cluster_token = undef,
  Optional[String]                        $control_plane = undef,
  Optional[String]                        $channel       = undef,
) {
  if $role != 'standalone' and $cluster_token == undef {
    fail("microk8s: role '${role}' requires microk8s::cluster_token")
  }
  if $role == 'worker' and $control_plane == undef {
    fail('microk8s: role worker requires microk8s::control_plane')
  }

  $gpu_values = '/etc/microk8s/gpu-operator-values.yaml'

  $all_addons = $gpu ? {
    true    => $addons + {
      'nvidia' => "--gpu-operator-driver host --gpu-operator-no-set-as-default-runtime --gpu-operator-values ${gpu_values}",
    },
    default => $addons,
  }

  contain microk8s::install
  contain microk8s::config
  contain microk8s::cluster

  Class['microk8s::install']
  -> Class['microk8s::config']
  -> Class['microk8s::cluster']
}
