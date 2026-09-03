node 'maestro.puppet.batchelornz.com' {
  include common
  include r10k
}

node 'nextcloud.puppet.batchelornz.com' {
  include common
  include nextcloud
}

node 'workstation.puppet.batchelornz.com' {
  include common
  include immich
}
