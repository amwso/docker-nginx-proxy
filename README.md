# docker-nginx-proxy

## Usage


```
docker run -d -p 80:80 -p 443:443 -v /data/proxy:/data amwso/nginx-proxy
```

edit `conf/nginx/nginx_upstream.conf` to add site name, domain and backend address.

since ssl_certificate & ssl_certificate_key do not accept variables now, we need to copy `conf/nginx/nginx_site_ssl_default.conf` to `conf/nginx/nginx_site_ssl_somesite.conf` when adding a ssl site, change the certificate path, server_name in the new file.

