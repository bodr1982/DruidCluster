#!/bin/bash

cd /apache-druid-0.14.1-incubating; java `cat conf/druid/broker/jvm.config | xargs` -cp conf/druid/_common:conf/druid/broker:lib/* org.apache.druid.cli.Main server broker >> /tmp/broker.log
