FROM openjdk:8-jdk

ENV ES_PKG_NAME elasticsearch-5.5.2

RUN \
  cd / && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch && \
  groupadd -g 1000 elasticsearch && \
  useradd elasticsearch -u 1000 -g 1000

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml
RUN apt-get update && \
    apt-get install supervisor munin munin-node -y


RUN apt-get purge git curl -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

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

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Define working directory.
WORKDIR /data
VOLUME ["/elasticsearch/", "/data" ]
EXPOSE 9200
EXPOSE 9300
CMD ["/usr/bin/supervisord", "-n"]