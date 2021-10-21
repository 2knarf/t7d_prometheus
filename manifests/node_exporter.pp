# @summary
#  Class for setting up node_exporter
# @param version
#   Which version of node_exporter should be used
# @example
#   include t7d_prometheus::node_exporter
#
class t7d_prometheus::node_exporter (String $version = '1.1.2') {

  file {'/usr/local/bin/node_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/node_exporter-${version}.linux-amd64/node_exporter"
  }

  user{'node_exporter':
    ensure     => present,
    comment    => 'Node exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/node_exporter.service':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/node_exporter.service'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/node_exporter.service'],
      require     => File['/etc/systemd/system/node_exporter.service'],
      refreshonly => true;
  }

  # Start and enable node_exporter with builtin service type from Puppet
  service{ 'node_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/node_exporter'],
    require   => [Exec['refresh_systemd'],File['/usr/local/bin/node_exporter']],
    hasstatus => true,
  }

  @@concat::fragment { "node_exporter_service-${::hostname}":
    target  => '/tmp/node-targets.yaml',
    content => "server ${::hostname} ${::ipaddress}",
    tag     => 'node_exporter_service',
  }

}
