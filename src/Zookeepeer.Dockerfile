FROM alpine:3.7

RUN apk add --no-cache bash

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u111
ENV JAVA_ALPINE_VERSION 8.111.14-r0

RUN set -x && apk add --no-cache openjdk8 && [ "$JAVA_HOME" = "$(docker-java-home)" ]

#RUN apk update && apk add mysql-client
#ENV MYSQL_USER admin
#ENV MYSQL_PASSWORD welcome1
#ENV MYSQL_DATABASE druid

#RUN apk add postgresql=10.8-r0
RUN apk add postgresql && apk add postgresql-client
RUN (addgroup -S postgres && adduser -S postgres -G postgres || true)
RUN mkdir -p /var/lib/postgresql/data
RUN mkdir -p /run/postgresql/
RUN chown -R postgres:postgres /run/postgresql/
RUN chmod -R 777 /var/lib/postgresql/data
RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN su - postgres -c "initdb /var/lib/postgresql/data"
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf
RUN echo "listen_addresses = '*'	" >> /var/lib/postgresql/data/postgresql.conf
RUN su - postgres -c "pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log && psql --command \"ALTER USER postgres WITH ENCRYPTED PASSWORD 'welcome1';\" && psql --command \"CREATE DATABASE druid;\" && psql --command \"grant all privileges on database druid to postgres;\""

COPY ./file/zookeeper-3.4.14.tar.gz /zookeeper-3.4.14.tar.gz
RUN tar -xzf /zookeeper-3.4.14.tar.gz
COPY ./conf/zookeeper/zoo.cfg /zookeeper-3.4.14/conf

COPY ./file/apache-druid-0.14.1-incubating-bin.tar.gz /apache-druid-0.14.1-incubating-bin.tar.gz
RUN tar -xzf /apache-druid-0.14.1-incubating-bin.tar.gz

COPY ./conf/druid/_common/common.runtime.properties /apache-druid-0.14.1-incubating/conf/druid/_common/common.runtime.properties
COPY ./file/postgresql-metadata-storage /apache-druid-0.14.1-incubating/extensions/postgresql-metadata-storage

RUN rm -rf *.tar.gz

COPY ./script/zookeeper/start.sh /start.sh
COPY ./script/postgres/run.sh /run.sh

RUN set -ex && apk --no-cache add sudo

EXPOSE 5432
EXPOSE 1527
EXPOSE 2181
EXPOSE 8081
EXPOSE 8090

RUN chmod +x /start.sh
RUN chmod +x /run.sh

CMD ["/start.sh"]
