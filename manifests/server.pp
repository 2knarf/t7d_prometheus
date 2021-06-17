#Server setup for Prometheus
class t7d_prometheus::server {
  concat { '/tmp/node-targets.yaml':
    ensure_newline => true,
    owner          => 'prometheus',
    group          => 'prometheus',
    mode           => '0660',
  }

  # We need this to make sure it will become a valid YAML file, so this needs to be at the beginning of the file.
  # This also where we could add custom labels
  concat::fragment { 'node-targets-header':
    target  => $job_targets_file,
    content => "---\n- labels:\n  environment: production\n- targets:\n",
    order   => 0,
  }

  # This is where the magic happens and how we collect the resources exported by the other nodes! \o/
  T7d_Prometheus::Node_Exporter <<| |>>

}
