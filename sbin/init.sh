#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DATA_PATH=/data
LOG_FILE_PATH=$DATA_PATH/var/log
CONF_PATH=$DATA_PATH/conf
TEMP_PATH=$DATA_PATH/tmp
ARACRON_PATH=$DATA_PATH/var/spool/anacron
LOGROTATE_PATH=$DATA_PATH/var/lib/logrotate
NGINX_CACHE_PATH=$DATA_PATH/var/cache/nginx


check_dir () {
	# build dir
	[[ ! -d $LOG_FILE_PATH/supervisor ]] && mkdir -p $LOG_FILE_PATH/supervisor
	[[ ! -d $LOG_FILE_PATH/nginx ]] && mkdir -p $LOG_FILE_PATH/nginx
	[[ ! -d $ARACRON_PATH ]] && mkdir -p $ARACRON_PATH
	[[ ! -d $LOGROTATE_PATH ]] && mkdir -p $LOGROTATE_PATH
	[[ ! -d $NGINX_CACHE_PATH ]] && mkdir -p $NGINX_CACHE_PATH
	[[ ! -d $CONF_PATH ]] && cp -rf /root/template/conf $CONF_PATH
	[[ ! -f $CONF_PATH/supervisor_service.conf ]] && cp -f /root/template/conf/supervisor_service.conf $CONF_PATH/supervisor_service.conf
	[[ ! -d $TEMP_PATH ]] && mkdir -p $TEMP_PATH
	chmod 1777 $TEMP_PATH
}

setup_upsteam () {
        if [ "x$NGINX_UPSTREAM" == "x" ] ; then
                echo "no upstream, exit."
		exit 1
	elif [[ ! $NGINX_UPSTREAM =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]+)?$ ]] ; then
		echo "bad upstream, exit."
		exit 1
        else
		echo "upstream http_backend { server $NGINX_UPSTREAM; keepalive 16; }" > $CONF_PATH/nginx/nginx_upstream.conf
        fi
}

check_dir
setup_upsteam

# load crontab
crontab $CONF_PATH/crontab.root
# run anacron once
anacron -t $CONF_PATH/anacrontab -S $ARACRON_PATH -n -d

# Forward SIGTERM to supervisord process
_term() {
	while kill -0 $child >/dev/null 2>&1
	do
		kill -TERM $child 2>/dev/null
		sleep 1
	done
}
trap _term 15
exec /usr/bin/supervisord -n &
child=$!

wait $child
