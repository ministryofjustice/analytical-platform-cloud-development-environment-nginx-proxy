#checkov:skip=CKV_DOCKER_3: Current implementation uses off-the-shelf image from OpenResty which doesn't offer a nonroot variant

# docker.io/openresty/openresty:1.27.1.2-1-alpine-fat
FROM docker.io/openresty/openresty:1.27.1.2-1-alpine-fat@sha256:a82c4d8bceb80cffd0bb427959f959c8a733bcbeedcfd3d3a7d82268c4518339

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Analytical Platform (analytical-platform@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Cloud Development Environment NGINX Proxy" \
      org.opencontainers.image.description="Cloud Development Environment NGINX proxy image for Analytical Platform" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/analytical-platform-cloud-development-environment-nginx-proxy"

ENV MOONROCK_MIRROR_COMMIT="daab2726276e3282dc347b89a42a5107c3500567" \
    LUA_RESTY_OPENIDC_VERSION="1.8.0"

# The installation of lua-resty-openidc is pinned to a specific commit of the moonrocks-mirror repository due to this issue https://github.com/luarocks/luarocks/issues/1797
# See specific comment https://github.com/luarocks/luarocks/issues/1797#issuecomment-2930518193 for the fix below
# At the time of next patch, test without `--only-server "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/${MOONROCK_MIRROR_COMMIT}"` and see if it works
RUN <<EOF
luarocks install --only-server "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/${MOONROCK_MIRROR_COMMIT}" lua-resty-openidc "${LUA_RESTY_OPENIDC_VERSION}"
EOF

COPY src/etc/nginx /etc/nginx
COPY src/opt/lua-scripts /opt/lua-scripts
COPY src/srv/www /srv/www
COPY --chown=nobody:nobody --chmod=0755 src/usr/local/bin /usr/local/bin

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD ["/usr/local/bin/healthcheck.sh"]
