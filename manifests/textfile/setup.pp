#Setup the base for textfile exporter
class t7d_prometheus::textfile::setup {
  case $facts['os']['name'] {
    'RedHat','CentOS': {
      include t7d_prometheus::textfile::yum
    }
    /^(Debian|Ubuntu)$/:  {
      include t7d_prometheus::textfile::apt
    }
  }

    file {'/var/lib/prometheus/node-exporter':
      ensure  => directory,
      require => File['/var/lib/prometheus'],
    }
    file {'/var/lib/prometheus':
      ensure => directory,
    }
    file {'/usr/share/prometheus-node-exporter-collectors':
      ensure => directory,
    }
    package { 'moreutils':
      ensure => 'present'
    }
}
