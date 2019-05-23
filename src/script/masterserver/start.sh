#!/bin/bash

/zookeeper-3.4.14/bin/zkServer.sh start
#su - postgres -c "export PGDATA=/var/lib/postgresql/data && nohup postgres >> /var/lib/postgresql/postgres.log &"
nohup sudo -u postgres postgres -D /var/lib/postgresql/data &
sleep 60
cd /apache-druid-0.14.1-incubating; java `cat conf/druid/coordinator/jvm.config | xargs` -cp conf/druid/_common:conf/druid/coordinator:lib/* org.apache.druid.cli.Main server coordinator >> /tmp/coordinator.log
cd /apache-druid-0.14.1-incubating; java `cat conf/druid/overlord/jvm.config | xargs` -cp conf/druid/_common:conf/druid/overlord:lib/* org.apache.druid.cli.Main server overlord >> /tmp/overlord.log
