FROM qnib/alpn-base

RUN apk --no-cache add wget \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "# dumb-init: $(/usr/local/bin/go-github rLatestUrl --ghorg Yelp --ghrepo dumb-init --regex ".*_amd64$" --limit 1)" \
 && wget -qO /usr/local/bin/dumb-init $(/usr/local/bin/go-github rLatestUrl --ghorg Yelp --ghrepo dumb-init --regex ".*_amd64" --limit 1) \
 && chmod +x /usr/local/bin/dumb-init \
 && echo "# init-plain: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo init-plain --regex "init-plain.tar" --limit 1)" \
 && wget -qO - $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo init-plain --regex "init-plain.tar" --limit 1) |tar xf - -C /usr/local/ \
 && rm -f /usr/local/bin/go-github
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

