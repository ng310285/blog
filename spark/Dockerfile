# Dockerfile to create image for a Spark as a Service cluster
# using Livy as the RESTful server to provide interactive query
# capability on demand.

FROM centos:latest 

RUN yum -y update
RUN yum -y install curl
RUN yum -y install wget
RUN yum -y install unzip

# JAVA

ENV JAVA_HOME /usr/local/jdk1.8.0_121
ENV PATH $JAVA_HOME/bin:$PATH

RUN cd /usr/local/
RUN wget -nv -P /usr/local --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"
RUN tar -C /usr/local -xzf /usr/local/jdk-8u121-linux-x64.tar.gz \
 && rm /usr/local/jdk-8u121-linux-x64.tar.gz 

# SPARK
ARG SPARK_ARCHIVE=http://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz
ENV SPARK_HOME /usr/local/spark-1.6.2-bin-hadoop2.6

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -s ${SPARK_ARCHIVE} | tar -xz -C /usr/local/

WORKDIR $SPARK_HOME

# Livy
ARG LIVY_ARCHIVE=http://archive.cloudera.com/beta/livy/livy-server-0.2.0.zip
RUN curl -s ${LIVY_ARCHIVE} > /usr/local/livy.zip
RUN unzip /usr/local/livy.zip -d /usr/local \
 && rm /usr/local/livy.zip