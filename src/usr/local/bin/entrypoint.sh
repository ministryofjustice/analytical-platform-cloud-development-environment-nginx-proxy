#!/usr/bin/env sh

set -e

export ERROR_LOG_LEVEL="${ERROR_LOG_LEVEL:-error}"
export PROXY_LISTEN_ADDRESS="${PROXY_LISTEN_ADDRESS:-"*"}"
export PROXY_LISTEN_PORT="${PROXY_LISTEN_PORT:-3000}"
export UPSTREAM_HOST="${UPSTREAM_HOST:-localhost}"
export UPSTREAM_PORT="${UPSTREAM_PORT:-8080}"

echo "Error log level: ${ERROR_LOG_LEVEL}"
echo "Proxy address: ${PROXY_LISTEN_ADDRESS}:${PROXY_LISTEN_PORT}"
echo "Upstream: ${UPSTREAM_HOST}:${UPSTREAM_PORT}"

echo "Createing NGINX configuration from template"
cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf

echo "Replacing placeholders in NGINX configuration"
sed -i "s/ERROR_LOG_LEVEL/${ERROR_LOG_LEVEL}/g" /etc/nginx/nginx.conf
sed -i "s/PROXY_LISTEN_ADDRESS/${PROXY_LISTEN_ADDRESS}/g" /etc/nginx/nginx.conf
sed -i "s/PROXY_LISTEN_PORT/${PROXY_LISTEN_PORT}/g" /etc/nginx/nginx.conf
sed -i "s/UPSTREAM_HOST/${UPSTREAM_HOST}/g" /etc/nginx/nginx.conf
sed -i "s/UPSTREAM_PORT/${UPSTREAM_PORT}/g" /etc/nginx/nginx.conf

echo "Testing NGINX configuration"
/usr/local/openresty/nginx/sbin/nginx -t -c /etc/nginx/nginx.conf

echo "Starting NGINX"
/usr/local/openresty/nginx/sbin/nginx -c /etc/nginx/nginx.conf
