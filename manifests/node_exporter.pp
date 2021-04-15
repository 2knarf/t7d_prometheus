#Class for setting up node_exporter
class t7d_prometheus::node_exporter {


  #TODO Make it possible to adjust version

  file {'/usr/local/bin/node_exporter':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/node_exporter-1.1.2.linux-amd64/node_exporter'
  }

  user{'node_exporter':
    ensure     => present,
    comment    => 'Node exporter',
    shell      => '/usr/bin/false',
    managehome => false
  }
  file {'/etc/systemd/system/node_exporter.service':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/node_exporter.service'

  }

#sudo systemctl daemon-reload
  exec {
    'refresh_systemd':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/node_exporter.service'],
      refreshonly => true;
  }
#sudo systemctl start node_exporter
  exec {
    'start_node_exporter_systemd':
      command     => '/bin/systemctl start node_exporter',
      require     => File['/etc/systemd/system/node_exporter.service'],
      refreshonly => true;
  }
#sudo systemctl enable node_exporter
  exec {
    'enable_node_exporter_systemd':
      command     => '/bin/systemctl enable node_exporter',
      require     => File['/etc/systemd/system/node_exporter.service'],
      refreshonly => true;
  }

  @@concat::fragment { "node_exporter_service-${::hostname}":
    target  => "/tmp/exporttest-${::hostname}",
    content => "server ${::hostname} ${::ipaddress}",
    tag     => 'node_exporter_service',
  }

}
