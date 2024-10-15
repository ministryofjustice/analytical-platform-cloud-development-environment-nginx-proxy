#!/usr/bin/env sh

set -e

# NGINX
export ERROR_LOG_LEVEL="${ERROR_LOG_LEVEL:-error}"
export PROXY_LISTEN_ADDRESS="${PROXY_LISTEN_ADDRESS:-"*"}"
export PROXY_LISTEN_PORT="${PROXY_LISTEN_PORT:-3000}"
export UPSTREAM_HOST="${UPSTREAM_HOST:-localhost}"
export UPSTREAM_PORT="${UPSTREAM_PORT:-8080}"

# Auth0
export ANALYTICAL_PLATFORM_TOOL_ID="${ANALYTICAL_PLATFORM_TOOL_ID:-vscode}"
export AUTH0_CLIENT_ID="${AUTH0_CLIENT_ID:-notarealclientid}"
export AUTH0_CLIENT_SECRET="${AUTH0_CLIENT_SECRET:-notarealclientsecret}"
export AUTH0_TENANT_DOMAIN="${AUTH0_TENANT_DOMAIN:-notarealauth0domain.auth0.com}"
export LOGOUT_URL="${LOGOUT_URL:-"https://google.com"}"
export REDIRECT_DOMAIN="${REDIRECT_DOMAIN:-"http://localhost:3000"}"
export USERNAME="${USERNAME:-analyticalplatform}"

echo "Error log level: ${ERROR_LOG_LEVEL}"
echo "Proxy address: ${PROXY_LISTEN_ADDRESS}:${PROXY_LISTEN_PORT}"
echo "Proxy Upstream: ${UPSTREAM_HOST}:${UPSTREAM_PORT}"

echo "Createing NGINX configuration from template"
cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf

echo "Replacing NGINX settings placeholders in NGINX configuration"
sed -i "s/ERROR_LOG_LEVEL/${ERROR_LOG_LEVEL}/g" /etc/nginx/nginx.conf
sed -i "s/PROXY_LISTEN_ADDRESS/${PROXY_LISTEN_ADDRESS}/g" /etc/nginx/nginx.conf
sed -i "s/PROXY_LISTEN_PORT/${PROXY_LISTEN_PORT}/g" /etc/nginx/nginx.conf
sed -i "s/UPSTREAM_HOST/${UPSTREAM_HOST}/g" /etc/nginx/nginx.conf
sed -i "s/UPSTREAM_PORT/${UPSTREAM_PORT}/g" /etc/nginx/nginx.conf

echo "Replacing Auth0 settings placeholders in NGINX configuration"
sed -i "s/ANALYTICAL_PLATFORM_TOOL_ID/${ANALYTICAL_PLATFORM_TOOL_ID}/g" /etc/nginx/nginx.conf
sed -i "s/AUTH0_CLIENT_ID/${AUTH0_CLIENT_ID}/g" /etc/nginx/nginx.conf
sed -i "s/AUTH0_CLIENT_SECRET/${AUTH0_CLIENT_SECRET}/g" /etc/nginx/nginx.conf
sed -i "s/AUTH0_TENANT_DOMAIN/${AUTH0_TENANT_DOMAIN}/g" /etc/nginx/nginx.conf
sed -i "s|LOGOUT_URL|${LOGOUT_URL}|g" /etc/nginx/nginx.conf
sed -i "s|REDIRECT_DOMAIN|${REDIRECT_DOMAIN}|g" /etc/nginx/nginx.conf
sed -i "s/USERNAME/${USERNAME}/g" /etc/nginx/nginx.conf

echo "Testing NGINX configuration"
/usr/local/openresty/nginx/sbin/nginx -t -c /etc/nginx/nginx.conf

echo "Starting NGINX"
/usr/local/openresty/nginx/sbin/nginx -c /etc/nginx/nginx.conf
