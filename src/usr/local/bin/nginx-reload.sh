#!/usr/bin/env sh

echo "Reloading Nginx configuration"
/usr/local/openresty/nginx/sbin/nginx -s reload
