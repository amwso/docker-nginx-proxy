# docker-nginx-proxy

## Usage

`NGINX_UPSTREAM` is required

```
docker run -d -e NGINX_UPSTREAM=172.17.42.1:8080 -p 80:80 -v /data/proxy:/data amwso/nginx-proxy
```

HTTPS support

```
docker run -d -e NGINX_UPSTREAM=172.17.42.1:8080 -p 80:80 -p 443:443 -e NGINX_ENABLE_SSL=yes -v /data/proxy:/data amwso/nginx-proxy
```
