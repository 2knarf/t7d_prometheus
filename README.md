# T7d Prometheus

This module requires that you have the following configuration on the server in prometheus.yml

```
    file_sd_configs:
      - files:
          - /etc/node-targets.yml
```
