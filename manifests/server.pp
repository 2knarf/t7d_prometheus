# @summary
#   Server setup for Prometheus
class t7d_prometheus::server {
  concat { '/tmp/node-targets.yaml':
    ensure_newline => true,
    owner          => 'prometheus',
    group          => 'prometheus',
    mode           => '0660',
  }

  Concat::Fragment <<| tag == 'node_exporter_service' |>>

}
