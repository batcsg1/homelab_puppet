# @summary Deploys Immich on MicroK8s via its Helm chart.
#
# Secrets come from Hiera (eyaml) and are written only into values.yaml on the node.
class immich_k8s (
  Sensitive[String[1]] $db_password,
  Sensitive[String[1]] $tunnel_token,
  String  $immich_version  = 'release',
  String  $timezone        = 'Pacific/Auckland',
  Integer $node_port       = 32283,
  Boolean $gpu_ml          = true,
  Boolean $gpu_transcoding = false,
  String  $upload_path     = '/srv/immich/storage',
  String  $db_path         = '/srv/immich/db',
  String  $samuel_library  = '/srv/immich/storage/external/admin',
  String  $carmen_library  = '/srv/immich/storage/external/1f6d1099-d3b2-4a90-894f-dee4a4f9d5de',
  String  $db_username     = 'postgres',
  String  $db_name         = 'immich',
  String  $chart_dir       = '/opt/immich-chart',
  String  $namespace       = 'immich',
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
