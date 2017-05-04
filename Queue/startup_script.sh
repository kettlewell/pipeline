#!/bin/bash

/kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties  > /kafka/log/zookeeper.log 2>&1 &
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties > /kafka/log/kafka.log 2>&1 &

service sshd start

#service cassandra start

#sleep 15
#cqlsh -f init_cassandra.cql
