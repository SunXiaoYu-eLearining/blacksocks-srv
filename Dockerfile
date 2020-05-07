FROM alpine:latest
LABEL Maintainer="jason <sunxiaoyu.space@outlook.com>" \
      Description="Shadowsocks client with v2ray plugin"

# change mirror
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk --update add \
        libsodium \
        tar \
        xz \
        gcc \
        git \
        autoconf \
        make \
        libtool \
        automake \
        zlib-dev \
        openssl \
        asciidoc \
        xmlto \
        libpcre32 \
        libev-dev g++ \
        linux-headers \
        proxychains-ng \
    && rm -rf /var/cache/apk/*

# Add shadowsocks & v2ray
RUN wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.8.8/shadowsocks-v1.8.8-stable.x86_64-unknown-linux-musl.tar.xz \
    && wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.0/v2ray-plugin-linux-amd64-v1.3.0.tar.gz \
    && tar xvJf shadowsocks-v1.8.8-stable.x86_64-unknown-linux-musl.tar.xz -C /usr/bin \
    && tar xvzf v2ray-plugin-linux-amd64-v1.3.0.tar.gz -C /usr/bin \
    && rm shadowsocks-v1.8.8-stable.x86_64-unknown-linux-musl.tar.xz v2ray-plugin-linux-amd64-v1.3.0.tar.gz \
    && git clone https://github.com/shadowsocks/simple-obfs.git \
    && cd simple-obfs \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure && make \
    && make install

VOLUME [ "/root" ]
CMD ["proxychains4", "/usr/bin/ssserver", "-c", "/root/server.json"]

EXPOSE 8388