#Install the yum status text exporter
class t7d_prometheus::textfile::yum {

  file {'/etc/systemd/system/prometheus-node-exporter-yum.service':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/prometheus-node-exporter-yum.service'
  }
  file {'/etc/systemd/system/prometheus-node-exporter-yum.timer':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/prometheus-node-exporter-yum.timer'
  }
  file {'/usr/share/prometheus-node-exporter-collectors/yum.sh':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/node-exporter-textfile-collector-scripts/yum.sh'
  }

  exec {
    'refresh_systemd_yum_timer':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/prometheus-node-exporter-yum.timer','/etc/systemd/system/prometheus-node-exporter-yum.service'],
      require     => File['/etc/systemd/system/prometheus-node-exporter-yum.timer','/etc/systemd/system/prometheus-node-exporter-yum.service'],
      refreshonly => true;
  }

  service{ 'prometheus-node-exporter-yum.timer':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/systemd/system/prometheus-node-exporter-yum.timer','/etc/systemd/system/prometheus-node-exporter-yum.service'],
    require   => File['/etc/systemd/system/prometheus-node-exporter-yum.timer','/etc/systemd/system/prometheus-node-exporter-yum.service'],
    hasstatus => true,
  }
}
