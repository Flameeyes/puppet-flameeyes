class flameeyes::tmux {
  case $::osfamily {
    default: {
      case $::operatingsystem {
        "Gentoo": {
	  $package = "app-misc/tmux"
        }
      }
    }
  }

  package { $package:
    ensure => installed
  }

  file { '/etc/tmux.conf':
    ensure => file,
    source => "puppet:///modules/flameeyes/tmux.conf",
  }
}
