class r10k (
  String $remote,
  String $basedir  = '/etc/puppet/code/environments',
  String $cachedir = '/var/cache/r10k',
  Boolean $manage_cron = false,
  String $cron_minute  = '*/15',
) {
  contain r10k::install
  contain r10k::config

  Class['r10k::install']
  -> Class['r10k::config']

  if $manage_cron {
    contain r10k::deploy
    Class['r10k::config'] -> Class['r10k::deploy']
  }
}
