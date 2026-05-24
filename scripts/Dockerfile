FROM alpine:3.16 AS builder
LABEL maintainer="tindy.it@gmail.com"
ARG THREADS="4"
ARG SHA=""

WORKDIR /src/subconverter
COPY . .
RUN set -xe && \
    [ -n "$SHA" ] && sed -i 's/\(v[0-9]\.[0-9]\.[0-9]\)/\1-'"$SHA"'/' src/version.h || true; \
    chmod +x scripts/build.alpine.release.sh && \
    bash scripts/build.alpine.release.sh

# build final image
FROM alpine:3.16
LABEL maintainer="tindy.it@gmail.com"

RUN apk add --no-cache --virtual subconverter-deps ca-certificates pcre2 openssl zlib yaml-cpp

COPY --from=builder /src/subconverter/subconverter/subconverter /usr/bin/
COPY --from=builder /src/subconverter/subconverter /base/

ENV TZ=Africa/Abidjan
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

# set entry
WORKDIR /base
CMD subconverter

EXPOSE 25500/tcp
