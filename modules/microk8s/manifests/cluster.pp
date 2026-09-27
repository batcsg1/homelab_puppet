# @summary Joins nodes into a MicroK8s cluster using a pre-shared token.
#
# control:    registers the token so workers can join.
# worker:     joins the control plane with that token.
# standalone: does nothing.
class microk8s::cluster {
  $mk8s   = '/snap/bin/microk8s'
  $tokens = '/var/snap/microk8s/current/credentials/cluster-tokens.txt'

  case $microk8s::role {
    'control': {
      $token = $microk8s::cluster_token.unwrap

      exec { 'microk8s-register-join-token':
        command => Sensitive("${mk8s} add-node --token ${token} --token-ttl 315360000"),
        unless  => Sensitive("/bin/grep -q ${token} ${tokens}"),
      }
    }
    'worker': {
      $token = $microk8s::cluster_token.unwrap

      exec { 'microk8s-join-cluster':
        command => Sensitive("${mk8s} join ${microk8s::control_plane}:25000/${token} --worker"),
        unless  => "${mk8s} status | /bin/grep -q 'acting as a node in a cluster'",
        timeout => 600,
      }
    }
    default: {}
  }
}
