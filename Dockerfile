FROM ubuntu:15.10
MAINTAINER HJay <trixism@qq.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN \
 cp /root/.bashrc /root/.profile / ; \
 echo 'HISTFILE=/dev/null' >> /.bashrc ; \
 HISTSIZE=0 ; \
 echo 'deb http://archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 echo 'deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list ; \
 apt-get update ; \
 apt-get -y upgrade ; \
 cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
 sed -i 's/UTC=yes/UTC=no/' /etc/default/rcS ; \
 apt-get -y install \
 curl wget \
 supervisor anacron nginx-extras


#RUN \
# echo "deb http://nginx.org/packages/ubuntu/ $(lsb_release -c -s) nginx" > /etc/apt/sources.list.d/nginx.list ; \
# echo "deb-src http://nginx.org/packages/ubuntu/ $(lsb_release -c -s) nginx" >> /etc/apt/sources.list.d/nginx.list ; \
# curl -sSL http://nginx.org/keys/nginx_signing.key | apt-key add - ; \
# apt-get update ; \
# apt-get -y install nginx


COPY ./sbin /root/sbin
COPY ./template /root/template

RUN mv /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.default ; \
 cp /root/template/conf/supervisord.conf /etc/supervisor/supervisord.conf ; \
 cp /root/template/conf/crontab /etc/crontab ; \
 cp /root/template/conf/cron.d/anacron /etc/cron.d/anacron

RUN \
 groupadd -g 5000 -r user_web ; \
 useradd -l -M -r  -s /usr/sbin/nologin -u 5000 -g 5000 user_web

EXPOSE 80

CMD ["/bin/bash","/root/sbin/init.sh"]
