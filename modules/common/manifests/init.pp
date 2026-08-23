# modules/common/manifests/init.pp
# Classes applied to every managed node in the environment.
class common {
   include sudo
   class { 'docker':
    daemon_settings => { 
      'ipv6'      => false,
      'data-root' => '/srv/docker',
    },
  }

  
}
