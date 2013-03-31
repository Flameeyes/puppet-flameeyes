class flameeyes::msmtp($relayhost, $fromaddress = '', $aliases = '/etc/aliases') {
  if $::operatingsystem == "Gentoo" {
    portage::package { "mail-mta/msmtp":
      use => [mta],
      alias => "msmtp"
    }
  } else {
    fail("The ${module_name} module is not supported on ${::osfamily}/${::operatingsystem}");
  }

  if $fromaddress == '' {
    $from = "nobody@${::fqdn}"
  } else {
    $from = $fromaddress
  }

  file { '/etc/msmtprc':
    require => Package['msmtp'],
    ensure => file,
    mode => '0755',
    content => template("${module_name}/msmtprc.erb",
  }
}
