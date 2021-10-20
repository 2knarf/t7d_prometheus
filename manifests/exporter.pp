# @summary
#  Class for setting up an exporter
# @param version
#   Which version of exporter should be used
# @param exporter
#   Which exporter should be used
# @example
#   include t7d_prometheus::exporter
#
define t7d_prometheus::exporter (String $exporter = undef, String $version = '1.1.2') {

  file {"/usr/local/bin/${exporter}_exporter":
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    source => "puppet:///modules/t7d_prometheus/${exporter}_exporter-${version}.linux-amd64/${exporter}_exporter"
  }

  user{"${exporter}_exporter":
    ensure     => present,
    comment    => "${exporter} exporter",
    shell      => '/bin/false',
    managehome => false
  }

  file {"/etc/systemd/system/${exporter}_exporter.service":
    ensure => present,
    mode   => '0755',
    source => "puppet:///modules/t7d_prometheus/${exporter}_exporter.service"

  }

  # sudo systemctl daemon-reload is required to pick up changes in the systemd directory
  exec {
    'refresh_systemd':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File["/etc/systemd/system/${exporter}_exporter.service"],
      require     => File["/etc/systemd/system/${exporter}_exporter.service"],
      refreshonly => true;
  }

  # Start and enable node_exporter with builtin service type from Puppet
  service{ "${exporter}_exporter":
    ensure    => running,
    enable    => true,
    require   => Exec['refresh_systemd'],
    hasstatus => true,
  }

  @@concat::fragment { "${exporter}_exporter_service-${::hostname}":
    target  => "/tmp/exporttest-${::hostname}",
    content => "server ${::hostname} ${::ipaddress}",
    tag     => "${exporter}_service",
  }

}
