# build stage
FROM golang:alpine AS build-env
LABEL maintainer="dev@jpillora.com"
RUN apk update
RUN apk add git
ENV CGO_ENABLED 0
ADD . /src
WORKDIR /src
RUN go build \
    -ldflags "-X github.com/myzhang1029/penguin/share.BuildVersion=$(git describe --abbrev=0 --tags)" \
    -o penguin
# container stage
FROM alpine
RUN apk update && apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=build-env /src/penguin /app/penguin
ENTRYPOINT ["/app/penguin"]
