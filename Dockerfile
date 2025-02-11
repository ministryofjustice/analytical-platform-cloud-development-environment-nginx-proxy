#checkov:skip=CKV_DOCKER_3: Current implementation uses off-the-shelf image from OpenResty which doesn't offer a nonroot variant

# docker.io/openresty/openresty:1.25.3.2-alpine-fat
FROM docker.io/openresty/openresty@sha256:15270690cb6334dcf9513d679586acec92e14ce7aafb70d14f72b8d579394c7f

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Analytical Platform (analytical-platform@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Cloud Development Environment NGINX Proxy" \
      org.opencontainers.image.description="Cloud Development Environment NGINX proxy image for Analytical Platform" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/analytical-platform-cloud-development-environment-nginx-proxy"

RUN <<EOF
luarocks install lua-resty-openidc 1.8.0
EOF

COPY src/etc/nginx /etc/nginx
COPY src/opt/lua-scripts /opt/lua-scripts
COPY src/srv/www /srv/www
COPY --chown=nobody:nobody --chmod=0755 src/usr/local/bin /usr/local/bin

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD ["/usr/local/bin/healthcheck.sh"]
