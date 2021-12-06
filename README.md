# T7d Prometheus

This module requires that you have the following configuration on the server in prometheus.yml

```
    file_sd_configs:
      - files:
          - /etc/node-targets.yml
```
## Limitations

Tested to work on Ubuntu 16.04, 18.04 and 20.04 as well as CentOS 7

## Mysql exporter

CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'XXXXXXXX' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
