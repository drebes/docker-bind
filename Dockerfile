FROM centos:centos7
MAINTAINER Roberto Jung Drebes <drebes@gmail.com>>
ENV BIND_DOMAIN=example.com.
ENV BIND_REVERSE_DOMAIN=1.168.192.in-addr.arpa
ENV BIND_UPSTREAM_DNS=8.8.8.8,8.8.4.4
ENV BIND_KEY_SECRET="c3VwZXJzZWNyZXQ="
ENV BIND_KEY_ALGORITHM="hmac-md5"
ENV BIND_INSECURE="false"
RUN yum -y install deltarpm && yum -y update && yum -y install bind
ADD startup.sh .
RUN mkdir -p /var/named/dynamic
VOLUME /var/named/dynamic
EXPOSE 53/udp
CMD ./startup.sh
