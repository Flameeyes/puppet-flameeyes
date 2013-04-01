class flameeyes::msmtp($relayhost, $fromaddress = '', $aliases = '/etc/aliases') {
  if $::operatingsystem == "Gentoo" {
    $package = "mail-mta/msmtp"

    portage::package { "mail-mta/msmtp":
      use => [mta],
    }
  } else {
    fail("The ${module_name} module is not supported on ${::osfamily}/${::operatingsystem}")
  }

  if $fromaddress == '' {
    $from = "nobody@${::fqdn}"
  } else {
    $from = $fromaddress
  }

  file { '/etc/msmtprc':
    require => Package[$package],
    ensure => file,
    mode => '0755',
    content => template("${module_name}/msmtprc.erb"),
  }
}
