ARG VRUST

FROM alpine:3 AS fetcher

ARG VPYOXI

RUN apk add --no-cache curl
RUN curl -sSL -o pyoxidizer.tar.gz https://github.com/indygreg/PyOxidizer/releases/download/pyoxidizer%2F${VPYOXI}/pyoxidizer-${VPYOXI}-x86_64-unknown-linux-musl.tar.gz && \
    tar zxf pyoxidizer.tar.gz && \
    mv pyoxidizer-${VPYOXI}-x86_64-unknown-linux-musl/pyoxidizer /pyoxidizer

FROM rust:${VRUST}

COPY --from=fetcher /pyoxidizer /usr/bin/pyoxidizer

ENV USER=root
ENV PYOXIDIZER_SYSTEM_RUST=1
