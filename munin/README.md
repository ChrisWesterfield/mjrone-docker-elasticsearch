# Munin plugin for elasticsearch

A useful Munin plugin for monitoring elasticsearch 1.x nodes in Perl.<br />
This original codes has out of maintenance, so I have started maintenance this plugin.

## Features

* Supports elasticsearch 1.0.x / 1.1.x / 1.2.x / 1.3.x / 1.4.x / 2.x / 5.x
* Supports monitoring local and/or another hosts

## Plugins

* elasticsearch_cache - field and filter cache stats
* elasticsearch_cluster_shards - cluster shards stats
* elasticsearch_docs - document count
* elasticsearch_gc_time - garbage collection time stats
* elasticsearch_index_size - index size
* elasticsearch_index_total - index total count
* elasticsearch_jvm_memory - JVM heap/non-heap memory usage
* elasticsearch_jvm_pools_size - JVM pools size stats
* elasticsearch_jvm_threads - JVM thread stats
* elasticsearch_open_files - open files count
* elasticsearch_translog_size - translog file size

## Configuration

### Variables

* env.host - a elasticsearch node capable of providing stats interface (default localhost)
* env.port - elasticsearch HTTP API port (default 9200)

### Example Config

Before use, put these settings into munin configuration.

  * examples of munin config file 
    *  in the case of all plugin config into single file.<br />
      `/etc/munin/plugin-conf.d/munin-node`
    * in the case of creating file per plugins.<br />
      `/etc/munin/plugin-conf.d/elasticsearch`

##### example of custom host and port configuration

```
[elasticsearch_*]
env.host localhost
env.port 9200
```

## Install

Install this plugins with following steps after config setuped.

```sh
# For centos
$ cd /usr/local/src/
$ sudo git clone https://github.com/y-ken/munin-plugin-elasticsearch.git
$ cd munin-plugin-elasticsearch
$ sudo cp -p elasticsearch_* /usr/share/munin/plugins/
$ sudo ln -s /usr/share/munin/plugins/elasticsearch_* /etc/munin/plugins/
$ sudo -H munin-node-configure --shell | grep elasticsearch | sudo -H sh
$ munin-node-configure | grep elasticsearch
$ sudo service munin-node restart
```

To confirm wokring fine or not, you can check like below.

```sh
$ munin-run elasticsearch_jvm_memory
heap_used.value 5017533904
heap_max.value 8520204288
heap_committed.value 8520204288
non_heap_used.value 60425328
non_heap_committed.value 90300416
```

## Author

* Original code by [@rafl](https://github.com/rafl) has imported from https://gist.github.com/2159398
* [Contributors to y-ken/munin-plugin-elasticsearch](https://github.com/y-ken/munin-plugin-elasticsearch/graphs/contributors)
* maintained by [@y-ken](https://github.com/y-ken)

## Licence

MIT License
