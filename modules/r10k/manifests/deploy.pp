class r10k::deploy {
  cron { 'r10k-deploy':
    command => '/usr/local/bin/r10k deploy environment production -p >> /var/log/r10k-deploy.log 2>&1',
    user    => 'root',
    minute  => $r10k::cron_minute,
  }
}
