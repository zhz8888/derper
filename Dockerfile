FROM golang AS builder
WORKDIR /app

ARG DERP_VERSION

RUN go install tailscale.com/cmd/derper@${DERP_VERSION}

FROM alpine
LABEL maintainer="https://github.com/zhz8888"

WORKDIR /app

RUN apk add --no-cache bash curl wget net-tools tar ca-certificates busybox-suid tzdata openssl
RUN ln -sf /bin/busybox /usr/bin/crontab
RUN mkdir /app/certs

ENV TZ Asia/Shanghai
ENV DERP_HOST your.hostname.com
ENV DERP_CERT_MODE letsencrypt
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :443
ENV DERP_STUN true
ENV DERP_STUN_PORT 3478
ENV DERP_HTTP_PORT 80
ENV DERP_VERIFY_CLIENTS false
ENV DERP_VERIFY_CLIENT_URL ""

COPY --from=builder /go/bin/derper /app/derper

CMD /app/derper --hostname=$DERP_HOST \
    --certmode=$DERP_CERT_MODE \
    --certdir=$DERP_CERT_DIR \
    --a=$DERP_ADDR \
    --stun=$DERP_STUN  \
    --stun-port=$DERP_STUN_PORT \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS \
    --verify-client-url=$DERP_VERIFY_CLIENT_URL