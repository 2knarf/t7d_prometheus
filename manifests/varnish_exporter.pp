# @summary
#  Class for setting up varnish_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of varnish_exporter should be used
# @example
#   include t7d_prometheus::varnish_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::varnish_exporter
#    t7d_prometheus::varnish_exporter:scrape_uri: "teknograd.no/server-status?auto"
#
class t7d_prometheus::varnish_exporter
(
  String $version = '1.6'
)

  {

  file {'/usr/local/bin/varnish_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/prometheus_varnish_exporter-${version}.linux-amd64/prometheus_varnish_exporter"
  }

  user{'varnish_exporter':
    ensure     => present,
    comment    => 'varnish exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/varnish_exporter.service':
    ensure  => present,
    mode    => '0755',
    content => epp('t7d_prometheus/varnish_exporter.service.epp'),
    #source => 'puppet:///modules/t7d_prometheus/varnish_exporter.service'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd_varnishexporter':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/varnish_exporter.service'],
      require     => File['/etc/systemd/system/varnish_exporter.service'],
      refreshonly => true;
  }

  # Start and enable varnish_exporter with builtin service type from Puppet
  service{ 'varnish_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/varnish_exporter'],
    require   => [Exec['refresh_systemd_varnishexporter'],File['/usr/local/bin/varnish_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9113']
  @@concat::fragment { "varnish_exporter_service-${::fqdn}":
    target  => '/etc/varnish-targets.yml',
    content => "- targets: ['${::fqdn}:9131']",
    tag     => 'varnish_exporter_service',
  }

}
