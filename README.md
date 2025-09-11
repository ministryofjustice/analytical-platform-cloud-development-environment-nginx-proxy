# Analytical Platform Cloud Development Environment NGINX Proxy

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/analytical-platform-cloud-development-environment-nginx-proxy/badge)](https://github-community.service.justice.gov.uk/repository-standards/analytical-platform-cloud-development-environment-nginx-proxy)

[![Open in Dev Container](https://raw.githubusercontent.com/ministryofjustice/.devcontainer/refs/heads/main/contrib/badge.svg)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/ministryofjustice/analytical-platform-cloud-development-environment-nginx-proxy)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ministryofjustice/analytical-platform-cloud-development-environment-nginx-proxy)

This repository contains the NGINX proxy container image used by the Cloud Development Environment tools on the Analytical Platform.

## Running Locally

### Build

```bash
make build
```

### Test

```bash
make test
```

### Run

```bash
make run
```

Open a browser <http://localhost:3000>

## Managing Software Versions

### Base Image

OpenResty maintain their [CHANGELOG](https://github.com/openresty/docker-openresty/blob/master/CHANGELOG.md)

```bash
docker pull --platform linux/amd64 docker.io/openresty/openresty:1.27.1.2-1-alpine-fat

docker image inspect --format='{{index .RepoDigests 0}}' docker.io/openresty/openresty:1.27.1.2-1-alpine-fat
```

### lua-resty-openidc

`lua-resty-openidc` versions are maintainer here <https://luarocks.org/modules/hanszandbelt/lua-resty-openidc>
