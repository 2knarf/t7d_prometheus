# @summary
#  Class for setting up mysqld_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of mysqld_exporter should be used
# @param user
#   Which user it should connect to mysqld as
# @param pass
#   Which password it should use to connect to mysqld
# @example
#   include t7d_prometheus::mysqld_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::mysqld_exporter
#    t7d_prometheus::mysqld_exporter:version: "0.13.0"
#    t7d_prometheus::mysqld_exporter::user: "stats"
#    t7d_prometheus::mysqld_exporter::pass: "statspass"
#
class t7d_prometheus::mysqld_exporter
(
  String $user = 'user',
  String $pass = 'pass',
  String $version = '0.13.0'
)

  {

  file {'/usr/local/bin/mysqld_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/mysqld_exporter-${version}.linux-amd64/mysqld_exporter"
  }

  user{'mysqld_exporter':
    ensure     => present,
    comment    => 'mysqld exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/mysqld_exporter.service':
    ensure  => present,
    mode    => '0755',
    require => File['/etc/.mysqld_exporter.cnf'],
    #content => epp('t7d_prometheus/mysqld_exporter.service.epp'),
    source  => 'puppet:///modules/t7d_prometheus/mysqld_exporter.service'
  }

  file {'/etc/.mysqld_exporter.cnf':
    ensure  => present,
    mode    => '0700',
    content => epp('t7d_prometheus/mysqld_exporter_default.epp'),
  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd_mysqldexporter':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/mysqld_exporter.service'],
      require     => File['/etc/systemd/system/mysqld_exporter.service'],
      refreshonly => true;
  }

  # Start and enable mysqld_exporter with builtin service type from Puppet
  service{ 'mysqld_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/mysqld_exporter'],
    require   => [Exec['refresh_systemd'],File['/usr/local/bin/mysqld_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9113']
  @@concat::fragment { "mysqld_exporter_service-${::fqdn}":
    target  => '/etc/mysqld-targets.yml',
    content => "- targets: ['${::fqdn}:9113']",
    tag     => 'mysqld_exporter_service',
  }

}
