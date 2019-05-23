#!/bin/bash

cd /apache-druid-0.14.1-incubating; java `cat conf/druid/historical/jvm.config | xargs` -cp conf/druid/_common:conf/druid/historical:lib/* org.apache.druid.cli.Main server historical >> /tmp/historical.log
cd /apache-druid-0.14.1-incubating; java `cat conf/druid/middleManager/jvm.config | xargs` -cp conf/druid/_common:conf/druid/middleManager:lib/* org.apache.druid.cli.Main server middleManager >> /tmp/middleManager.log
