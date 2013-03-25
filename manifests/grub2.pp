class flameeyes::grub2 {
  if $::operatingsystem == "Gentoo" {
    package_keywords { 'sys-boot/grub': version => "=2*", keywords => "**", }
    package_unmask { 'sys-boot/grub': version => "=2*", }

    package { 'sys-boot/grub': version => "=2*", ensure => installed, }

    file { '/etc/kernel/postinst.d/99grub2':
      ensure => file,
      owner => root,
      mode => 0755,
      require => Package['sys-boot/grub'],
      source => "puppet:///modules/flameeyes/grub2.kernel.postinst",
    }
  }
}
