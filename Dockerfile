# -----------------------------------------------------------------------------
# Build...
FROM golang:1.14.4-alpine AS build

WORKDIR /popeye

COPY go.mod go.sum main.go Makefile ./
COPY internal internal
COPY cmd cmd
COPY types types
COPY pkg pkg
RUN apk --no-cache add make git gcc libc-dev curl ca-certificates && make build

# -----------------------------------------------------------------------------
# Image...
FROM alpine:3.11.2
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /popeye/execs/popeye /bin/popeye

ENTRYPOINT [ "/bin/popeye" ]