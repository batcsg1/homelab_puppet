node 'maestro.puppet.batchelornz.com' {
  include common
  include r10k
  include prometheus
  include puppet::server
  include grafana
}

node 'nextcloud.puppet.batchelornz.com' {
  include common
  include puppet::agent
  include nextcloud
}

node 'workstation.puppet.batchelornz.com' {
  include common
  include puppet::agent
  include immich
}

node 'cm1.puppet.batchelornz.com' {
  include common
  class { 'puppet::server':
    ca_master => false,
  }
}
