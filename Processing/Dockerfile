# FROM centos:centos7
FROM pipeline/image

# RUN yum -y update && yum clean all
RUN yum -y install epel-release # && yum clean all


LABEL version="spark_2.1_hadoop_2.7"

RUN yum -y install R python python-dev python-pip \
           python-virtualenv curl wget htop git man \
	   unzip emacs-nox java-1.8.0-openjdk \
	   java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless

ARG JAVA_MAJOR_VERSION=8

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /etc/alternatives/java_sdk

ARG SPARK_VERSION="v2.1.0"
RUN mkdir /spark
RUN git clone  --depth 1 --branch ${SPARK_VERSION} https://github.com/apache/spark.git

WORKDIR /spark
RUN which Rscript

ENV R_HOME /usr/
RUN ./R/install-dev.sh

ENV MAVEN_OPTS "-Xmx2g -XX:ReservedCodeCacheSize=512m"
ARG MAJOR_HADOOP_VERSION="2.7"
RUN ./build/mvn -Pyarn -Psparkr -Pmesos -Phive -Phive-thriftserver -Phadoop-${MAJOR_HADOOP_VERSION} -Dhadoop.version=${MAJOR_HADOOP_VERSION}.0 -DskipTests clean package

ENV SPARK_HOME /spark

expose 4040

CMD ["/spark/bin/spark-shell"]

######################
######################

#ENV SPARK_HOME /spark

#ENV PATH /spark/bin:/spark/sbin:$PATH

#Startup (start SSH, Cassandra, Zookeeper, Kafka producer)
#ADD startup_script.sh /usr/bin/startup_script.sh
#RUN chmod +x /usr/bin/startup_script.sh

#Environment variables for Spark and Java
#ADD setenv.sh /root/setenv.sh
#RUN echo . /root/setenv.sh >> .bashrc
