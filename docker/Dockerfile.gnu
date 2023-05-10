ARG VRUST

FROM alpine:3 AS fetcher

ARG TARGETARCH
ARG VPYOXI

RUN apk add --no-cache curl
RUN case ${TARGETARCH} in \
        "amd64")  R_ARCH=x86_64  ;; \
        "arm64")  R_ARCH=aarch64  ;; \
    esac && \
    curl -sSL -o pyoxidizer.tar.gz https://github.com/indygreg/PyOxidizer/releases/download/pyoxidizer%2F${VPYOXI}/pyoxidizer-${VPYOXI}-${R_ARCH}-unknown-linux-musl.tar.gz && \
    tar zxf pyoxidizer.tar.gz && \
    mv pyoxidizer-${VPYOXI}-${R_ARCH}-unknown-linux-musl/pyoxidizer /pyoxidizer

FROM rust:${VRUST}

COPY --from=fetcher /pyoxidizer /usr/bin/pyoxidizer

ENV USER=root
ENV PYOXIDIZER_SYSTEM_RUST=1
