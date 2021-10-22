# @summary
#  Class for setting up process_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of process_exporter should be used
# @example
#   include t7d_prometheus::process_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::process_exporter
# @see
#   https://github.com/ncabatoff/process-exporter 
class t7d_prometheus::process_exporter (String $version = '0.7.7') {

  file {'/usr/local/bin/process_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/process-exporter-${version}.linux-amd64/process-exporter"
  }

  user{'process_exporter':
    ensure     => present,
    comment    => 'process exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/process_exporter.service':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/t7d_prometheus/process_exporter.service'

  }
  file {'/etc/default/process_exporter':
    ensure  => present,
    mode    => '0755',
    require => File['/etc/systemd/system/process_exporter.service'],
    source  => 'puppet:///modules/t7d_prometheus/default/process_exporter'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd_process_exporter':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/process_exporter.service'],
      require     => File['/etc/systemd/system/process_exporter.service'],
      refreshonly => true;
  }

  # Start and enable node_exporter with builtin service type from Puppet
  service{ 'process_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/process_exporter'],
    require   => [Exec['refresh_systemd_process_exporter'],File['/usr/local/bin/process_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9113']
  @@concat::fragment { "process_exporter_service-${::fqdn}":
    target  => '/etc/process-targets.yml',
    content => "- targets: ['${::fqdn}:9256']",
    tag     => 'process_exporter_service',
  }

}
