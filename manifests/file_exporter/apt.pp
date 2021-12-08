#Install the apt status text exporter
class t7d_prometheus::node_exporter::textfile::apt {

    file {'/usr/local/bin/node_exporter_text_apt':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/t7d_prometheus/node-exporter-textfile-collector-scripts/apt.sh'
    }
}
