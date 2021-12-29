FROM rust:latest as builder

ENV LIBDIR /usr/lib/redis/modules
ENV DEPS "python python-setuptools python3-pip wget unzip build-essential clang cmake git"

# Set up a build environment
RUN set -ex;\
    deps="$DEPS";\
    apt-get update; \
    apt-get install -y --no-install-recommends $deps;\
    pip install rmtest

RUN mkdir /RedisJSON
RUN git clone https://github.com/RedisJSON/RedisJSON /RedisJSON

# Build the source
ADD . /REJSON
WORKDIR /REJSON
RUN mv /RedisJSON/* .
RUN set -ex;\
    cargo build --release;\
    mv target/release/librejson.so target/release/rejson.so;

# Package the runner
FROM redis:6.2.6-bullseye
ENV LIBDIR /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p "$LIBDIR";
COPY --from=builder /REJSON/target/release/rejson.so "$LIBDIR"
COPY redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]