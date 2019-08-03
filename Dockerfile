ARG CENTOS_VERSION=7.6.1810
FROM centos:$CENTOS_VERSION
MAINTAINER Roberto Jung Drebes <drebes@gmail.com>>
ARG CONFD_VERSION=0.16.0
RUN curl -L -o confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 && chmod a+x confd
RUN yum -y install deltarpm && yum -y update && yum -y install bind
ADD confd /etc/confd
ADD scripts .
RUN mkdir -p /var/named/dynamic
VOLUME /var/named/dynamic
EXPOSE 53/udp
CMD ./startup.sh
