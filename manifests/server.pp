# @summary
#   Server setup for Prometheus
class t7d_prometheus::server {

  service { 'prometheus':
    ensure => 'running'
  }

  concat { '/etc/node-targets.yml':
    ensure_newline => true,
    owner          => 'root',
    notify         => Service['prometheus'],
    group          => 'root',
    mode           => '0665',
  }

  Concat::Fragment <<| tag == 'node_exporter_service' |>>
}
