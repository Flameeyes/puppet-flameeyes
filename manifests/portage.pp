class flameeyes::portage (
  $use,
  $cflags = '-pipe -O2 -march=native -ggdb',
  $cxxflags = '${CFLAGS}',
  $chost = '',
  $extra_features = '',
  $makeopts = '',
  $extra_emerge_options = '',
  $sync = "rsync://rsync.gentoo.org/gentoo-portage",
  $mirrors = '',
  $python_targets = "python2_7",
  $ruby_targets = "ruby19",
  $log = true,
  $profile
  ) {
    include portage

    if $chost == '' {
      $real_chost = $::hardwaremodel ? {
        x86_64 => "x86_64-pc-linux-gnu",
        i686   => "i686-pc-linux-gnu",
        default => ''
      }

      if $real_chost == '' {
        fail("Unable to get a default chost")
      }
    } else {
      $real_chost = $chost
    }

    $makeconf = {
      'cflags'  => { content => "${cflags}" },
      'cxxflags'=> { content => "${cxxflags}" },
      'features'=> { content => "userpriv usersandbox parallel-fetch splitdebug split-logs ${extra_features}" },
      'EMERGE_DEFAULT_OPTS' => { content => "--quiet-build --keep-going ${extra_emerge_options}" },
      'makeopts'=> { content => "${makeopts}" },
      'sync'    => { content => "${sync}" },
      'GENTOO_MIRRORS' => { content => "$mirrors" },
      'portdir' => { content => "/var/cache/portage/tree" },
      'distdir' => { content => "/var/cache/portage/distfiles" },
      'pkgdir'  => { content => "/var/spool/portage/packages" },
      'chost'   => { content => "${real_chost}" },
      'PORTAGE_COMPRESS' => { content => "xz" },
      'LINGUAS' => { content => "en" },
      'PYTHON_TARGETS' => { content => "${python_targets}" },
      'RUBY_TARGETS' => { content => "${ruby_targets}" },
    }

    # these are optional
    if $ldflags != '' {
      portage::makeconf { 'LDFLAGS':
        content => "${ldflags}",
        ensure => present,
      }
    }

    if $log {
      portage::makeconf { 'PORT_LOGDIR':
        content => '/var/log/portage',
        ensure => present,
      }
    }

    $packageuses = {
      'app-arch/tarsnap': { use => [ 'lzma' ] },
      'sys-libs/pam': { use => [ '-berkdb' ] },
      'sys-fs/lvm2': { use => [ '-lvm1', '-thin' ] },
    }

    create_resources('portage::makeconf', $makeconf, { ensure => 'present' })
    create_resources('package_use', $packageuses)

    # remove the alternative name since it would sidestep puppet itself :/
    file { '/etc/portage/package.accept_keywords':
      ensure => absent,
      force => true,
      recurse => true,
    }

    eselect { 'profile':
      set => $profile,
    }
  }
