class t7d_prometheus::node_exporter {


  #TODO Make it possible to adjust version

  file {'/usr/local/bin/node_exporter':
    ensure  => file,
    mode    => 0755,
    content =>('t7d_prometheus/node_exporter-1.1.2.linux-amd64/node_exporter')
  }
  user{'node_exporter':
    ensure     => present,
    comment    => 'Node exporter',
    shell      => '/usr/bin/false',
    managehome => false
  }
}
