#Install the apt status text exporter
class t7d_prometheus::textfile::apt {

  file {'/etc/systemd/system/prometheus-node-exporter-apt.service':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/prometheus-node-exporter-apt.service'
  }
  file {'/etc/systemd/system/prometheus-node-exporter-apt.timer':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/prometheus-node-exporter-apt.timer'
  }
  file {'/usr/share/prometheus-node-exporter-collectors/apt.sh':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/node-exporter-textfile-collector-scripts/apt.sh'
  }

  exec {
    'refresh_systemd_apt_timer':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/prometheus-node-exporter-apt.timer','/etc/systemd/system/prometheus-node-exporter-apt.service'],
      require     => File['/etc/systemd/system/prometheus-node-exporter-apt.timer','/etc/systemd/system/prometheus-node-exporter-apt.service'],
      refreshonly => true;
  }

  service{ 'prometheus-node-exporter-apt.timer':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/systemd/system/prometheus-node-exporter-apt.timer','/etc/systemd/system/prometheus-node-exporter-apt.service'],
    require   => File['/etc/systemd/system/prometheus-node-exporter-apt.timer','/etc/systemd/system/prometheus-node-exporter-apt.service'],
    hasstatus => true,
  }
}
