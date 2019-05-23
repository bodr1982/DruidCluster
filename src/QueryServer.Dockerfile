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

COPY ./file/apache-druid-0.14.1-incubating-bin.tar.gz /apache-druid-0.14.1-incubating-bin.tar.gz
RUN tar -xzf /apache-druid-0.14.1-incubating-bin.tar.gz

COPY ./conf/druid/data&query/_common/common.runtime.properties /apache-druid-0.14.1-incubating/conf/druid/_common/common.runtime.properties
COPY ./conf/druid/broker/jvm.config /apache-druid-0.14.1-incubating/conf/druid/broker/jvm.config

RUN rm -rf *.tar.gz

COPY ./script/queryserver/start.sh /start.sh

EXPOSE 8082
EXPOSE 8088

RUN chmod +x /start.sh

CMD ["/start.sh"]
