FROM centos:centos7

# Zookeeper Repo
RUN yum install -y https://archive.cloudera.com/cdh5/one-click-install/redhat/7/x86_64/cloudera-cdh-5-0.x86_64.rpm

# Epel Repo
RUN yum install -y epel-release
RUN yum -y update;
RUN yum -y clean all;

# Install basic tools
RUN yum install -y  zookeeper wget bzip2  unzip java-1.8.0-openjdk java-1.8.0-openjdk-devel bind-utils python-pip

RUN yum -y clean all;


WORKDIR /

#Install Kafka
COPY ./kafka_2.11-0.10.0.0.tgz /
#RUN wget http://apache.belnet.be/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz
RUN tar -zxvf kafka_2.11-0.10.0.0.tgz
RUN mv kafka_2.11-0.10.0.0 /kafka
RUN mkdir -p /kafka/log

ENV PATH /kafka/bin:$PATH

#Install Kafka Python module
RUN pip install kafka-python supervisor

#Startup (start SSH, Cassandra, Zookeeper, Kafka producer)
ADD startup_script.sh /usr/bin/startup_script.sh
RUN chmod +x /usr/bin/startup_script.sh

#Environment variables for Spark and Java
ADD setenv.sh /root/setenv.sh
RUN echo . /root/setenv.sh >> .bashrc

ADD start-kafka.sh /usr/bin/start-kafka.sh

ADD supervisor.conf /etc/supervisord.conf

# Supervisor config
ADD kafka.conf zookeeper.conf /etc/supervisord/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092
ENV KAFKA_HOME /kafka
RUN echo_supervisord_conf
CMD ["/usr/bin/supervisord", "-n"]
#ENTRYPOINT ["/bin/bash"]

# Kafka and Zookeeper

#FROM java:openjdk-8-jre

#ENV DEBIAN_FRONTEND noninteractive
#ENV SCALA_VERSION 2.11
#ENV KAFKA_VERSION 0.10.1.0
#ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Install Kafka, Zookeeper and other needed things
#RUN apt-get update && \
#    apt-get install -y zookeeper wget supervisor dnsutils && \
#    rm -rf /var/lib/apt/lists/* && \
#    apt-get clean && \
#    wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
#    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
#    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

#ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
#ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
#EXPOSE 2181 9092

#CMD ["supervisord", "-n"]
