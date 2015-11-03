FROM ubuntu:14.04
MAINTAINER HJay <trixism@qq.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN \
 cp /root/.bashrc /root/.profile / ; \
 echo 'HISTFILE=/dev/null' >> /.bashrc ; \
 HISTSIZE=0 ; \
 echo 'deb http://archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 echo 'deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 apt-get update ; \
 apt-get -y upgrade ; \
 cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
 sed -i 's/UTC=yes/UTC=no/' /etc/default/rcS ; \
 apt-get -y install \
 curl wget \
 supervisor


RUN \
 echo "deb http://nginx.org/packages/ubuntu/ $(lsb_release -c -s) nginx" > /etc/apt/sources.list.d/nginx.list ; \
 echo "deb-src http://nginx.org/packages/ubuntu/ $(lsb_release -c -s) nginx" >> /etc/apt/sources.list.d/nginx.list ; \
 curl -sSL http://nginx.org/keys/nginx_signing.key | apt-key add - ; \
 apt-get update ; \
 apt-get -y install nginx
