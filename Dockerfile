ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=library
ARG FROM_IMG_NAME="alpine"
ARG FROM_IMG_TAG="edge"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

RUN apk --no-cache add --repository http://dl-4.alpinelinux.org/alpine/edge/testing tar \
 && apk --no-cache add ca-certificates bash wget \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "# init-plain: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo init-plain --regex 'init-plain.tar' --limit 1)" \
 && wget -qO - "$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo init-plain --regex 'init-plain.tar' --limit 1)" |tar xf - --strip-components=1 -C / \
 && echo "Download: $(/usr/local/bin/go-github rLatestUrl --ghorg tianon --ghrepo gosu --regex 'gosu-amd64' --limit 1)" \
 && wget -qO /usr/local/bin/gosu $(/usr/local/bin/go-github rLatestUrl --ghorg tianon --ghrepo gosu --regex 'gosu-amd64' --limit 1) \
 && chmod +x /usr/local/bin/gosu \
 && echo "# go-fisherman: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo go-fisherman --regex '.*_Alpine' --limit 1)" \
 && wget -qO /usr/local/bin/go-fisherman "$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo go-fisherman --regex '.*_Alpine' --limit 1)" \
 && chmod +x /usr/local/bin/go-fisherman \
 && rm -f /usr/local/bin/go-github
RUN adduser -h /home/user/ -s /sbin/nologin -u 1000 -D user
HEALTHCHECK --interval=5s --retries=5 --timeout=2s \
  CMD /usr/local/bin/healthcheck.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
