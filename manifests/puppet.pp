class flameeyes::puppet($master = false) {
  case $::osfamily {
    'RedHat': {
      $package = 'puppet'
    }
    
    default: {
      case $::operatingsystem {
        "Gentoo": {
          package_keywords { 'app-admin/puppet':
            version => '~3.1.1'
          }

          package_keywords { 'dev-ruby/hiera':
            version => '~1.1.2'
          }

          package_use { 'sys-apps/net-tools':
            use => 'old-output'
          }

          if $master {
            $use = [ 'shadow' ]
          } else {
            $use = [ 'shadow', 'minimal' ]
          }

          package_use { 'app-admin/puppet':
            use => $use
          }

          $package = "app-admin/puppet"
        }
      }
    }
  }

  package { $package:
    ensure => installed
  }

  service { 'puppet':
    subscribe => Package[$package],
    ensure => running,
    enable => true,
  }

  if $master {
    service { 'puppetmaster':
      subscribe => Package[$package],
      ensure => running,
      enable => true,
    }
  }
}
