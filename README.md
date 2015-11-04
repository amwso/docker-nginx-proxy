# docker-nginx-proxy

## Usage

`NGINX_UPSTREAM` is required

```
docker run -d -e NGINX_UPSTREAM=172.17.42.1:8080 -p 80:80 -v /data/proxy:/data amwso/nginx-proxy
```
