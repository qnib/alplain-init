FROM qnib/alpn-base

ENV DUMB_INIT_VER=1.0.1 \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/qnib/consul/bin/
RUN apk add --update wget \
 && wget -qO /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VER}/dumb-init_${DUMB_INIT_VER}_amd64 \
 && chmod +x /usr/local/bin/dumb-init \
 && wget -qO /usr/local/bin/entrypoint.sh https://raw.githubusercontent.com/qnib/init-plain/master/bin/entrypoint.sh \
 && chmod +x /usr/local/bin/entrypoint.sh \
 && apk del wget \
 && rm -rf /var/cache/apk/*
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

