# @summary Deploys Immich on MicroK8s via its Helm chart.
#
# Defaults live in the module's data/common.yaml; override them in environment Hiera.
# Secrets (db_password, tunnel_token) must come from environment Hiera (eyaml).
class immich_k8s (
  Sensitive[String[1]] $db_password,
  Sensitive[String[1]] $tunnel_token,
  String  $immich_version,
  String  $timezone,
  Integer $node_port,
  Boolean $gpu_ml,
  Boolean $gpu_transcoding,
  String  $nfs_server,
  String  $nfs_path,
  String  $samuel_library,
  String  $carmen_library,
  String  $db_path,
  String  $db_username,
  String  $db_name,
  String  $chart_dir,
  String  $namespace,
) {
  require microk8s

  contain immich_k8s::config

  microk8s::helm_release { 'immich':
    chart       => $chart_dir,
    namespace   => $namespace,
    values_file => "${chart_dir}/values.yaml",
    subscribe   => Class['immich_k8s::config'],
  }
}
