FROM alpine:3.16 AS builder
LABEL maintainer="metacubex.official@gmail.com"
ARG THREADS="4"
ARG SHA=""

# build minimized
WORKDIR /src
RUN set -xe && \
    apk add --no-cache --virtual .build-tools git g++ build-base linux-headers cmake make autoconf automake libtool python3 py3-pip ca-certificates && \
    apk add --no-cache --virtual .build-deps openssl-dev zlib-dev rapidjson-dev pcre2-dev yaml-cpp-dev && \
    git clone https://github.com/curl/curl --depth=1 --branch curl-8_6_0 && \
    cd curl && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCURL_USE_OPENSSL=ON -DHTTP_ONLY=ON -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_USE_LIBSSH2=OFF -DBUILD_CURL_EXE=OFF -DCURL_USE_LIBPSL=OFF -DHAVE_LIBIDN2=OFF . && \
    make install -j $THREADS && \
    cd .. && \
    git clone https://github.com/ftk/quickjspp --depth=1 && \
    cd quickjspp && \
    git submodule update --init && \
    cmake -DCMAKE_BUILD_TYPE=Release . && \
    make quickjs -j $THREADS && \
    install -d /usr/lib/quickjs/ && \
    install -m644 quickjs/libquickjs.a /usr/lib/quickjs/ && \
    install -d /usr/include/quickjs/ && \
    install -m644 quickjs/quickjs.h quickjs/quickjs-libc.h /usr/include/quickjs/ && \
    install -m644 quickjspp.hpp /usr/include && \
    cd .. && \
    git clone https://github.com/PerMalmberg/libcron --depth=1 && \
    cd libcron && \
    git submodule update --init && \
    cmake -DCMAKE_BUILD_TYPE=Release . && \
    make libcron -j $THREADS && \
    install -m644 libcron/out/Release/liblibcron.a /usr/lib/ && \
    install -d /usr/include/libcron/ && \
    install -m644 libcron/include/libcron/* /usr/include/libcron/ && \
    install -d /usr/include/date/ && \
    install -m644 libcron/externals/date/include/date/* /usr/include/date/ && \
    cd .. && \
    git clone https://github.com/ToruNiina/toml11 --branch="v4.3.0" --depth=1 && \
    cd toml11 && \
    cmake -DCMAKE_CXX_STANDARD=11 . && \
    make install -j $THREADS && \
    cd .. && \
    true

WORKDIR /src/subconverter
COPY . .
RUN set -xe && \
    [ -n "$SHA" ] && sed -i 's/\(v[0-9]\.[0-9]\.[0-9]\)/\1-'"$SHA"'/' src/version.h || true; \
    python3 -m pip install gitpython && \
    python3 scripts/update_rules.py -c scripts/rules_config.conf && \
    cmake -DCMAKE_BUILD_TYPE=Release . && \
    make -j $THREADS

# build final image
FROM alpine:3.16
LABEL maintainer="metacubex.official@gmail.com"

RUN apk add --no-cache --virtual subconverter-deps ca-certificates pcre2 openssl zlib yaml-cpp

COPY --from=builder /usr/lib/libcurl.so* /usr/lib/
COPY --from=builder /src/subconverter/subconverter /usr/bin/
COPY --from=builder /src/subconverter/base /base/

ENV TZ=Africa/Abidjan
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

# set entry
WORKDIR /base
CMD subconverter

EXPOSE 25500/tcp
