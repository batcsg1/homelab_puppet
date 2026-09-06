node 'maestro.puppet.batchelornz.com' {
  include common
  include r10k
  include prometheus
  include grafana
}

node 'nextcloud.puppet.batchelornz.com' {
  include common
  include nextcloud
}

node 'workstation.puppet.batchelornz.com' {
  include common
  include immich
}

node 'cm1.puppet.batchelornz.com' {
  include common
}
