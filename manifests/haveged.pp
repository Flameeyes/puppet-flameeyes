class flameeyes::haveged {
  package { 'sys-apps/haveged':
    ensure => present,
  }

  file { '/etc/conf.d/haveged':
    ensure => file,
    content => "HAVEGED_OPTS='-v 1'",
    require => Package['sys-apps/haveged'],
  }

  service { 'haveged':
    ensure => running,
    enable => true,
    subscribe => [Package['sys-apps/haveged'], File['/etc/conf.d/haveged']],
    hasrestart => true,
  }

  if $::kernelrelease =~ /-hardened/ {
    $watermark = 15360
  } else {
    $watermark = 3700
  }

  sysctl::value { 'kernel.random.write_wakeup_threshold':
    content => $watermark
  }
}
