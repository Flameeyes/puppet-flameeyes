class flameeyes::grub2 {
  if $::operatingsystem == "Gentoo" {
    portage::package { 'sys-boot/grub':
      ensure => "=2*",
      keywords => "**",
      keywords_version => "=2*",
      unmask => "=2*"
    }

    file { '/etc/kernel/postinst.d/99grub2':
      ensure => file,
      owner => root,
      mode => 0755,
      require => Package['sys-boot/grub'],
      source => "puppet:///modules/flameeyes/grub2.kernel.postinst",
    }
  }
}
