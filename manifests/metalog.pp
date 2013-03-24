class flameeyes::metalog {
  package { 'app-admin/metalog':
    ensure => present,
  }
  
  file { '/etc/metalog.conf':
    ensure => file,
    source => "puppet:///modules/flameeyes/metalog.conf",
  }

  service { 'metalog':
    ensure => running,
    enable => true,
    subscribe => File['/etc/metalog.conf'],
    require => Package['app-admin/metalog'],
    hasrestart => true,
  }
}
