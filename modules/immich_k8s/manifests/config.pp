# @summary Ships the Immich chart and renders values.yaml from Hiera.
class immich_k8s::config {
  # Locals for the ERB template
  $immich_version  = $immich_k8s::immich_version
  $timezone        = $immich_k8s::timezone
  $node_port       = $immich_k8s::node_port
  $gpu_ml          = $immich_k8s::gpu_ml
  $gpu_transcoding = $immich_k8s::gpu_transcoding
  $upload_path     = $immich_k8s::upload_path
  $db_path         = $immich_k8s::db_path
  $samuel_library  = $immich_k8s::samuel_library
  $carmen_library  = $immich_k8s::carmen_library
  $db_username     = $immich_k8s::db_username
  $db_name         = $immich_k8s::db_name
  $db_password     = $immich_k8s::db_password
  $tunnel_token    = $immich_k8s::tunnel_token

  # Postgres runs as UID 999 and requires 0700 on its data dir
  file { $db_path:
    ensure => directory,
    owner  => 999,
    group  => 999,
    mode   => '0700',
  }

  file { $immich_k8s::chart_dir:
    ensure  => directory,
    source  => 'puppet:///modules/immich_k8s/chart',
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 'root',
  }

  file { "${immich_k8s::chart_dir}/values.yaml":
    ensure    => file,
    content   => Sensitive(template('immich_k8s/values.yaml.erb')),
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    show_diff => false,
  }
}
