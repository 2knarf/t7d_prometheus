# @summary
#  Class for setting up systemd_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of systemd_exporter should be used
# @example
#   include t7d_prometheus::systemd_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::systemd_exporter
# @see
#   https://github.com/povilasv/systemd_exporter
class t7d_prometheus::systemd_exporter (String $version = '0.4.0') {

  file {'/usr/local/bin/systemd_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/systemd_exporter-${version}.linux-amd64/systemd_exporter"
  }

  user{'systemd_exporter':
    ensure     => present,
    comment    => 'systemd exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/systemd_exporter.service':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/process_exporter.service'

  }
  file {'/etc/default/systemd_exporter':
    ensure  => present,
    mode    => '0755',
    require => File['/etc/systemd/system/systemd_exporter.service'],
    source  => 'puppet:///modules/t7d_prometheus/default/systemd_exporter'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd_systemd_exporter':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/systemd_exporter.service'],
      require     => File['/etc/systemd/system/systemd_exporter.service'],
      refreshonly => true;
  }

  # Start and enable node_exporter with builtin service type from Puppet
  service{ 'systemd_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/systemd_exporter'],
    require   => [Exec['refresh_systemd_systemd_exporter'],File['/usr/local/bin/systemd_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9113']
  @@concat::fragment { "systemd_exporter_service-${::fqdn}":
    target  => '/etc/systemd-targets.yml',
    content => "- targets: ['${::fqdn}:9558']",
    tag     => 'systemd_exporter_service',
  }

}
