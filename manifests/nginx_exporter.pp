# @summary
#  Class for setting up nginx_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of nginx_exporter should be used
# @param scrape_uri
#   What URL is nginx stub status located
# @example
#   include t7d_prometheus::nginx_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::nginx_exporter
#    t7d_prometheus::nginx_exporter::scrape_uri: "localhost/nginx_status"
#
class t7d_prometheus::nginx_exporter
(
  String $scrape_uri = '"http://localhost/server-status"',
  String $version = '0.9.0'
)

  {

  file {'/usr/local/bin/nginx_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/nginx_exporter-${version}.linux-amd64/nginx_exporter"
  }

  user{'nginx_exporter':
    ensure     => present,
    comment    => 'nginx exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/nginx_exporter.service':
    ensure  => present,
    mode    => '0755',
    content => epp('t7d_prometheus/nginx_exporter.service.epp'),
    #source => 'puppet:///modules/t7d_prometheus/nginx_exporter.service'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd_nginxexporter':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/nginx_exporter.service'],
      require     => File['/etc/systemd/system/nginx_exporter.service'],
      refreshonly => true;
  }

  # Start and enable nginx_exporter with builtin service type from Puppet
  service{ 'nginx_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/nginx_exporter'],
    require   => [Exec['refresh_systemd'],File['/usr/local/bin/nginx_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9113']
  @@concat::fragment { "nginx_exporter_service-${::fqdn}":
    target  => '/etc/nginx-targets.yml',
    content => "- targets: ['${::fqdn}:9113']",
    tag     => 'nginx_exporter_service',
  }

}
