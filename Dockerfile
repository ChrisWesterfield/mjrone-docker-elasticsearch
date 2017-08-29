FROM elasticsearch:5
MAINTAINER Christopher Westerfield <chris@mjr.one>

USER root

RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install munin munin-node python-pip sudo && \
    pip install PyMunin
RUN echo "elasticsearch ALL=(root) NOPASSWD:/usr/sbin/munin-node" >> /etc/sudoers
COPY munin/elasticsearch_cache /usr/share/munin/plugins/elasticsearch_cache
COPY munin/elasticsearch_cluster_shards /usr/share/munin/plugins/elasticsearch_cluster_shards
COPY munin/elasticsearch_docs /usr/share/munin/plugins/elasticsearch_docs
COPY munin/elasticsearch_gc_time /usr/share/munin/plugins/elasticsearch_gc_time
COPY munin/elasticsearch_index_size /usr/share/munin/plugins/elasticsearch_index_size
COPY munin/elasticsearch_index_total /usr/share/munin/plugins/elasticsearch_index_total
COPY munin/elasticsearch_jvm_memory /usr/share/munin/plugins/elasticsearch_jvm_memory
COPY munin/elasticsearch_jvm_pools_size /usr/share/munin/plugins/elasticsearch_jvm_pools_size
COPY munin/elasticsearch_jvm_threads /usr/share/munin/plugins/elasticsearch_jvm_threads
COPY munin/elasticsearch_open_files /usr/share/munin/plugins/elasticsearch_open_files
COPY munin-node.conf /etc/munin/munin-node.conf
RUN chmod +x /usr/share/munin/plugins/elasticsearch*
RUN ln -s /usr/share/munin/plugins/elasticsearch_cache /etc/munin/plugins/elasticsearch_cache && \
    ln -s /usr/share/munin/plugins/elasticsearch_cluster_shards /etc/munin/plugins/elasticsearch_cluster_shards && \
    ln -s /usr/share/munin/plugins/elasticsearch_gc_time /etc/munin/plugins/elasticsearch_gc_time && \
    ln -s /usr/share/munin/plugins/elasticsearch_index_size /etc/munin/plugins/elasticsearch_index_size && \
    ln -s /usr/share/munin/plugins/elasticsearch_index_total /etc/munin/plugins/elasticsearch_index_total && \
    ln -s /usr/share/munin/plugins/elasticsearch_jvm_memory /etc/munin/plugins/elasticsearch_jvm_memory && \
    ln -s /usr/share/munin/plugins/elasticsearch_jvm_pools_size /etc/munin/plugins/elasticsearch_jvm_pools_size && \
    ln -s /usr/share/munin/plugins/elasticsearch_jvm_threads /etc/munin/plugins/elasticsearch_jvm_threads && \
    ln -s /usr/share/munin/plugins/elasticsearch_open_files /etc/munin/plugins/elasticsearch_open_files
COPY munin.sh /munin.sh
RUN yum clean all
USER elasticsearch

ENV ES_JAVA_OPTS="-Des.path.conf=/etc/elasticsearch"
VOLUME ["/usr/share/elasticsearch/config/elasticsearch.yml", "/var/lib/elasticsearch", "/var/log/elasticsearh" ]
CMD ["-E", "network.host=0.0.0.0", "-E", "discovery.zen.minimum_master_nodes=1"]

