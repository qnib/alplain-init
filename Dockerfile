# syntax=docker/dockerfile:1.4
ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=library
ARG FROM_IMG_NAME="alpine"
ARG FROM_IMG_TAG="3.19.0"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}
ARG TARGETARCH
ARG GOGH_VER=0.3.2
ARG GOSU_VER=1.17
ARG INIT_PLAIN_VER=0.5.1
ENV ENTRYPOINTS_DIR=/opt/qnib/entry/

RUN <<eot ash
 apk --no-cache upgrade
 apk add --no-cache bash
 apk --no-cache add --repository http://dl-4.alpinelinux.org/alpine/edge/testing tar
 apk --no-cache add ca-certificates bash wget
 echo https://gitlab.com/qnib-golang/go-github/-/releases/v${GOGH_VER}/downloads/go-github_${GOGH_VER}_linux_${TARGETARCH}.tar.gz
 wget -qO /usr/local/bin/go-github https://gitlab.com/qnib-golang/go-github/-/releases/v${GOGH_VER}/downloads/go-github_${GOGH_VER}_linux_${TARGETARCH}.tar.gz
 chmod +x /usr/local/bin/go-github
 wget -qO - https://github.com/qnib/init-plain/releases/download/v${INIT_PLAIN_VER}/init-plain.tar |tar xf - --strip-components=1 -C /
 wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VER}/gosu-${TARGETARCH} 
 chmod +x /usr/local/bin/gosu
eot
RUN adduser -h /home/user/ -s /sbin/nologin -u 1000 -D user
HEALTHCHECK --interval=5s --retries=5 --timeout=2s \
  CMD /usr/local/bin/healthcheck.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
