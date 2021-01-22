FROM alpine as builder
ENV NGINX_VERSION 1.19.6
RUN apk add build-base zlib-dev pcre-dev openssl-dev
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz && \
    cd /nginx-${NGINX_VERSION} && ./configure \
    --with-stream \
    --with-stream_ssl_preread_module \
    --with-stream_ssl_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-threads \
    && make && make install

FROM alpine
RUN apk add pcre openssl
COPY --from=builder /usr/local/nginx/ /usr/local/nginx/
ADD proxy_connect.conf /usr/local/nginx/conf/nginx.conf
CMD /usr/local/nginx/sbin/nginx