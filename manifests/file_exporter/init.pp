#Setup the base for textfile exporter
class t7d_prometheus::node_exporter::textfile {

    file {'/var/lib/prometheus/node-exporter':
      ensure  => directory,
      require => File['/var/lib/prometheus'],
    }
    file {'/var/lib/prometheus':
      ensure => directory,
    }
    package { 'moreutils':
      ensure => 'present'
    }
}
