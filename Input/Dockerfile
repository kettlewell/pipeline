FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install nodejs npm nodejs-typescript sysstat wget tar bzip2 unzip ; yum clean all

#FROM node:7.8

#RUN apt-get update && apt-get -y upgrade
#RUN apt-get -y install sysstat wget

# Root user
RUN echo "root:123456" | chpasswd

# Create directories for socket.io , notebooks and anaconda2
RUN mkdir /socket.io
RUN mkdir /notebooks
RUN mkdir /anaconda2

# copy notebooks src
ADD notebooks /notebooks

#Install Anaconda Python distribution
WORKDIR /anaconda2
ADD Anaconda2-4.1.1-Linux-x86_64.sh  /anaconda2/Anaconda2-4.1.1-Linux-x86_64.sh
#RUN wget http://repo.continuum.io/archive/Anaconda2-4.1.1-Linux-x86_64.sh
RUN bash Anaconda2-4.1.1-Linux-x86_64.sh -b -f -p /anaconda2
ENV PATH /anaconda2/bin:$PATH
RUN /anaconda2/bin/conda install python=2.7.10 -y
RUN /anaconda2/bin/conda install jupyter -y
RUN rm  /anaconda2/Anaconda2-4.1.1-Linux-x86_64.sh

# install socket.io packages and src
WORKDIR /socket.io
COPY socket.io/package.json /socket.io
RUN npm install
COPY ./socket.io /socket.io

#Install Kafka Python module
RUN pip install kafka-python

# Startup (start SSH )
ADD startup_script.sh /usr/bin/startup_script.sh
RUN chmod +x /usr/bin/startup_script.sh

# Environment variables
ADD setenv.sh /root/setenv.sh
RUN echo . /root/setenv.sh >> /root/.bashrc

EXPOSE 8888

#CMD ["npm","start"]
ENTRYPOINT ["npm","start"]
