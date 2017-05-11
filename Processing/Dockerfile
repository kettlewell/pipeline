# FROM centos:centos7
FROM pipeline/image

# RUN yum -y update && yum clean all
RUN yum -y install epel-release # && yum clean all

# FROM ubuntu:16.04
LABEL version="spark_2.1_hadoop_2.7"

# Install Python.
#RUN \
#  apt-get update && \
#  apt-get install -y python python-dev python-pip python-virtualenv && \
#  rm -rf /var/lib/apt/lists/*

RUN yum -y install R python python-dev python-pip python-virtualenv curl wget htop git man unzip emacs-nox java-1.8.0-openjdk java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless


# Install R
#RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list && \
#    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
#    gpg -a --export E084DAB9 | apt-key add - && \
#    apt-get update && \
#    apt-get install -y r-base r-base-dev

# Install system tools
#RUN \
#  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
#  apt-get update && \
#  apt-get -y upgrade && \
#  apt-get install -y build-essential && \
#  apt-get install -y software-properties-common && \
#  apt-get install -y byobu curl git htop man unzip nano wget && \
#  rm -rf /var/lib/apt/lists/*

ARG JAVA_MAJOR_VERSION=8

# Install Java
#RUN \
#  echo oracle-java${JAVA_MAJOR_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
#  add-apt-repository -y ppa:webupd${JAVA_MAJOR_VERSION}team/java && \
#  apt-get update && \
#  apt-get install -y oracle-java${JAVA_MAJOR_VERSION}-installer && \
#  rm -rf /var/lib/apt/lists/* && \
#  rm -rf /var/cache/oracle-jdk${JAVA_MAJOR_VERSION}-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /etc/alternatives/java_sdk

#RUN apt-get install git

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

#Install Spark
#Spark 2.0.0, precompiled with : mvn -Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.0 -Dyarn.version=2.6.0 -DskipTests -Dscala-2.11 -Phive -Phive-thriftserver clean package
#RUN mkdir /spark
#WORKDIR /spark
#RUN wget http://litpc45.ulb.ac.be/spark-2.0.0_Hadoop-2.6_Scala-2.11.tgz
#RUN tar xvzf spark-2.0.0_Hadoop-2.6_Scala-2.11.tgz

#ENV SPARK_HOME /spark

#ENV PATH /spark/bin:/spark/sbin:$PATH

#Startup (start SSH, Cassandra, Zookeeper, Kafka producer)
#ADD startup_script.sh /usr/bin/startup_script.sh
#RUN chmod +x /usr/bin/startup_script.sh

#Environment variables for Spark and Java
#ADD setenv.sh /root/setenv.sh
#RUN echo . /root/setenv.sh >> .bashrc
