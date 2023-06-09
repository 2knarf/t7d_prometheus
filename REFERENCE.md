# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`t7d_prometheus::apache_exporter`](#t7d_prometheusapache_exporter): Class for setting up apache_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::mysqld_exporter`](#t7d_prometheusmysqld_exporter): Class for setting up mysqld_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::nginx_exporter`](#t7d_prometheusnginx_exporter): Class for setting up nginx_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::node_exporter`](#t7d_prometheusnode_exporter): Class for setting up node_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::phpfpm_exporter`](#t7d_prometheusphpfpm_exporter): Class for setting up phpfpm_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::process_exporter`](#t7d_prometheusprocess_exporter): Class for setting up process_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::server`](#t7d_prometheusserver): Server setup for Prometheus
* [`t7d_prometheus::systemd_exporter`](#t7d_prometheussystemd_exporter): Class for setting up systemd_exporter and exporting configuration to PuppetDB
* [`t7d_prometheus::varnish_exporter`](#t7d_prometheusvarnish_exporter): Class for setting up varnish_exporter and exporting configuration to PuppetDB

## Classes

### <a name="t7d_prometheusapache_exporter"></a>`t7d_prometheus::apache_exporter`

Class for setting up apache_exporter and exporting configuration to PuppetDB

#### Examples

##### 

```puppet
include t7d_prometheus::apache_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::apache_exporter
 t7d_prometheus::apache_exporter:scrape_uri: "teknograd.no/server-status?auto"
```

#### Parameters

The following parameters are available in the `t7d_prometheus::apache_exporter` class:

* [`version`](#version)
* [`scrape_uri`](#scrape_uri)

##### <a name="version"></a>`version`

Data type: `String`

Which version of apache_exporter should be used

Default value: `'0.10.1'`

##### <a name="scrape_uri"></a>`scrape_uri`

Data type: `String`

What url to scrape status from

Default value: `'"http://localhost/server-status?auto"'`

### <a name="t7d_prometheusmysqld_exporter"></a>`t7d_prometheus::mysqld_exporter`

Class for setting up mysqld_exporter and exporting configuration to PuppetDB

#### Examples

##### 

```puppet
include t7d_prometheus::mysqld_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::mysqld_exporter
 t7d_prometheus::mysqld_exporter:version: "0.13.0"
 t7d_prometheus::mysqld_exporter::user: "stats"
 t7d_prometheus::mysqld_exporter::pass: "statspass"
```

#### Parameters

The following parameters are available in the `t7d_prometheus::mysqld_exporter` class:

* [`version`](#version)
* [`user`](#user)
* [`pass`](#pass)

##### <a name="version"></a>`version`

Data type: `String`

Which version of mysqld_exporter should be used

Default value: `'0.13.0'`

##### <a name="user"></a>`user`

Data type: `String`

Which user it should connect to mysqld as

Default value: `'user'`

##### <a name="pass"></a>`pass`

Data type: `String`

Which password it should use to connect to mysqld

Default value: `'pass'`

### <a name="t7d_prometheusnginx_exporter"></a>`t7d_prometheus::nginx_exporter`

Class for setting up nginx_exporter and exporting configuration to PuppetDB

#### Examples

##### 

```puppet
include t7d_prometheus::nginx_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::nginx_exporter
 t7d_prometheus::nginx_exporter:scrape_uri: "teknograd.no/server-status?auto"
```

#### Parameters

The following parameters are available in the `t7d_prometheus::nginx_exporter` class:

* [`version`](#version)
* [`scrape_uri`](#scrape_uri)

##### <a name="version"></a>`version`

Data type: `String`

Which version of nginx_exporter should be used

Default value: `'0.9.0'`

##### <a name="scrape_uri"></a>`scrape_uri`

Data type: `String`

What URL is nginx stub status located

Default value: `'"http://localhost/server-status"'`

### <a name="t7d_prometheusnode_exporter"></a>`t7d_prometheus::node_exporter`

Class for setting up node_exporter and exporting configuration to PuppetDB

#### Examples

##### 

```puppet
include t7d_prometheus::node_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::node_exporter
```

#### Parameters

The following parameters are available in the `t7d_prometheus::node_exporter` class:

* [`version`](#version)

##### <a name="version"></a>`version`

Data type: `String`

Which version of node_exporter should be used

Default value: `'1.1.2'`

### <a name="t7d_prometheusphpfpm_exporter"></a>`t7d_prometheus::phpfpm_exporter`

Class for setting up phpfpm_exporter and exporting configuration to PuppetDB

* **Note** Should create something like this:
--phpfpm.scrape-uri "unix:///var/run/php/moller-php7.4-fpm.sock;/server-status-phpfpm74-moller" --phpfpm.scrape-uri "unix:///var/run/php/nmh-php7.4-fpm.sock;/server-status-phpfpm74-nmh"

#### Examples

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
  - t7d_prometheus::phpfpm_exporter
t7d_prometheus::phpfpm_exporter::scrape_sock:
  - 'unix:///var/run/php/www1.sock;/status'
  - 'unix:///var/run/php/www2.sock;/status'
```

#### Parameters

The following parameters are available in the `t7d_prometheus::phpfpm_exporter` class:

* [`version`](#version)
* [`scrape_sock`](#scrape_sock)

##### <a name="version"></a>`version`

Data type: `String`

Which version of phpfpm_exporter should be used

Default value: `'2.0.3'`

##### <a name="scrape_sock"></a>`scrape_sock`

Data type: `Array[String]`

What URL is phpfpm stub status located

Default value: `['foo','bar']`

### <a name="t7d_prometheusprocess_exporter"></a>`t7d_prometheus::process_exporter`

Class for setting up process_exporter and exporting configuration to PuppetDB

* **See also**
  * https://github.com/ncabatoff/process-exporter

#### Examples

##### 

```puppet
include t7d_prometheus::process_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::process_exporter
```

#### Parameters

The following parameters are available in the `t7d_prometheus::process_exporter` class:

* [`version`](#version)

##### <a name="version"></a>`version`

Data type: `String`

Which version of process_exporter should be used

Default value: `'0.7.7'`

### <a name="t7d_prometheusserver"></a>`t7d_prometheus::server`

Server setup for Prometheus

### <a name="t7d_prometheussystemd_exporter"></a>`t7d_prometheus::systemd_exporter`

Class for setting up systemd_exporter and exporting configuration to PuppetDB

* **See also**
  * https://github.com/povilasv/systemd_exporter

#### Examples

##### 

```puppet
include t7d_prometheus::systemd_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::systemd_exporter
```

#### Parameters

The following parameters are available in the `t7d_prometheus::systemd_exporter` class:

* [`version`](#version)

##### <a name="version"></a>`version`

Data type: `String`

Which version of systemd_exporter should be used

Default value: `'0.4.0'`

### <a name="t7d_prometheusvarnish_exporter"></a>`t7d_prometheus::varnish_exporter`

Class for setting up varnish_exporter and exporting configuration to PuppetDB

#### Examples

##### 

```puppet
include t7d_prometheus::varnish_exporter
```

##### 

```puppet
File: data/nodes/puppetdevclient03.teknograd.no.yaml
---
classes:
 - t7d_prometheus::varnish_exporter
```

#### Parameters

The following parameters are available in the `t7d_prometheus::varnish_exporter` class:

* [`version`](#version)

##### <a name="version"></a>`version`

Data type: `String`

Which version of varnish_exporter should be used

Default value: `'1.6'`

