# @summary
#   Server setup for Prometheus
class t7d_prometheus::server {

  exec {
    'refresh_prometheus':
      command     => '/bin/systemctl reload prometheus',
      refreshonly => true;
  }

  concat { '/etc/node-targets.yml':
    ensure_newline => true,
    owner          => 'root',
    notify         => Exec['refresh_prometheus'],
    group          => 'root',
    mode           => '0665',
  }
  concat { '/etc/process-targets.yml':
    ensure_newline => true,
    owner          => 'root',
    notify         => Exec['refresh_prometheus'],
    group          => 'root',
    mode           => '0665',
  }
  concat { '/etc/apache-targets.yml':
    ensure_newline => true,
    owner          => 'root',
    notify         => Exec['refresh_prometheus'],
    group          => 'root',
    mode           => '0665',
  }
  #  concat { '/etc/systemd-targets.yml':
  #  ensure_newline => true,
  #  owner          => 'root',
  #  notify         => Exec['refresh_prometheus'],
  #  group          => 'root',
  #  mode           => '0665',
  #}

  Concat::Fragment <<| tag == 'node_exporter_service' |>>
  Concat::Fragment <<| tag == 'process_exporter_service' |>>
  Concat::Fragment <<| tag == 'apache_exporter_service' |>>
  Concat::Fragment <<| tag == 'nginx_exporter_service' |>>
  Concat::Fragment <<| tag == 'varnish_exporter_service' |>>
  #  Concat::Fragment <<| tag == 'systemd_exporter_service' |>>
}
