#Server setup for Prometheus
class t7d_prometheus::server {
  #TODO collect resources from client and populate to config
  Concat::Fragment <<| tag == 'node_exporter_service' |>>
}
