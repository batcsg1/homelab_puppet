class r10k::install {
  package { 'r10k':
    ensure   => installed,
    provider => 'gem',
  }
}
