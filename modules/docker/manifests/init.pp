class docker (
  Array[String]             $packages        = ['docker-ce', 'docker-ce-cli', 'containerd.io', 'docker-compose-plugin'],
  Array[String]             $docker_users    = ['docker'],
  Hash                      $daemon_settings = {},
  Enum['running','stopped'] $service_ensure  = 'running',
  Boolean                   $service_enable  = true,
) {
  contain docker::install
  contain docker::config
  contain docker::service

  # Enforce structural application order
  Class['docker::install']
  -> Class['docker::config']
  ~> Class['docker::service']

  # Ensure kernel-level changes in install also trigger service refreshes
  Class['docker::install'] ~> Class['docker::service']
}
