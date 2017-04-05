FROM alpine:3.5

RUN apk add --no-cache 'su-exec>=0.2' bash
RUN apk --no-cache add --repository http://dl-4.alpinelinux.org/alpine/edge/testing tar \
 && apk --no-cache add ca-certificates bash wget \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "# init-plain: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo init-plain --regex 'init-plain.tar' --limit 1)" \
 && wget -qO - "$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo init-plain --regex 'init-plain.tar' --limit 1)" |tar xf - --strip-components=1 -C / \
 && rm -f /usr/local/bin/go-github
RUN adduser -h /home/user/ -s /sbin/nologin -u 1000 -D user
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
