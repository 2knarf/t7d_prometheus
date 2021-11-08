# @summary
#  Class for setting up phpfpm_exporter and exporting configuration to PuppetDB
# @param version
#   Which version of phpfpm_exporter should be used
# @param scrape_sock
#   What URL is phpfpm stub status located
# @example
#   include t7d_prometheus::phpfpm_exporter
# @example
#   File: data/nodes/puppetdevclient03.teknograd.no.yaml
#   ---
#   classes:
#    - t7d_prometheus::phpfpm_exporter
#    t7d_prometheus::phpfpm_exporter:scrape_sock: "teknograd.no/server-status?auto"
#
# @note
#   Should create something like this:
#   --phpfpm.scrape-uri "unix:///var/run/php/moller-php7.4-fpm.sock;/server-status-phpfpm74-moller" --phpfpm.scrape-uri "unix:///var/run/php/nmh-php7.4-fpm.sock;/server-status-phpfpm74-nmh"
class t7d_prometheus::phpfpm_exporter
(
  $scrape_sock = ['a','b'],
  String $version = '2.0.3'
)

  {

  file {'/usr/local/bin/phpfpm_exporter':
    ensure => file,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/php-fpm_exporter_${version}_linux_amd64"
  }

  user{'phpfpm_exporter':
    ensure     => present,
    comment    => 'phpfpm exporter',
    shell      => '/bin/false',
    managehome => false
  }

  file {'/etc/systemd/system/phpfpm_exporter.service':
    ensure  => present,
    mode    => '0755',
    content => epp('t7d_prometheus/phpfpm_exporter.service.epp'),
    #source => 'puppet:///modules/t7d_prometheus/phpfpm_exporter.service'

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd_phpfpmexporter':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/phpfpm_exporter.service'],
      require     => File['/etc/systemd/system/phpfpm_exporter.service'],
      refreshonly => true;
  }

  # Start and enable phpfpm_exporter with builtin service type from Puppet
  service{ 'phpfpm_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/usr/local/bin/phpfpm_exporter'],
    require   => [Exec['refresh_systemd'],File['/usr/local/bin/phpfpm_exporter']],
    hasstatus => true,
  }

  #  This should end up like this on the prom server:  - targets: ['apt-web01.teknograd.no:9253']
  @@concat::fragment { "phpfpm_exporter_service-${::fqdn}":
    target  => '/etc/phpfpm-targets.yml',
    content => "- targets: ['${::fqdn}:9253']",
    tag     => 'phpfpm_exporter_service',
  }

}
