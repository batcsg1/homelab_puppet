node 'maestro.puppet.batchelornz.com' {
  include common
  include r10k
  include prometheus
}

node 'nextcloud.puppet.batchelornz.com' {
  include common
  include nextcloud
}

node 'workstation.puppet.batchelornz.com' {
  include common
  include immich
}
