# @summary
#  Class for setting up apache_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of apache_exporter should be used
# @example
#   include t7d_prometheus::apache_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::apache_exporter
#
class t7d_prometheus::apache_exporter (String $version = '0.10.1') {

  file {'/usr/local/bin/apache_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/apache_exporter-${version}.linux-amd64/apache_exporter"
  }

  user{'apache_exporter':
    ensure     => present,
    comment    => 'apache exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/apache_exporter.service':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/apache_exporter.service'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/apache_exporter.service'],
      require     => File['/etc/systemd/system/apache_exporter.service'],
      refreshonly => true;
  }

  # Start and enable apache_exporter with builtin service type from Puppet
  service{ 'apache_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/apache_exporter'],
    require   => [Exec['refresh_systemd'],File['/usr/local/bin/apache_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9113']
  @@concat::fragment { "apache_exporter_service-${::fqdn}":
    target  => '/etc/node-targets.yml',
    content => "- targets: ['${::fqdn}:9117']",
    tag     => 'apache_exporter_service',
  }

}
