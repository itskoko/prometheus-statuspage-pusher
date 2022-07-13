FROM golang:1.18
WORKDIR /build
ADD . .
RUN go mod download
RUN CGO_ENABLED=0 go build -o /prometheus-status-pusher

FROM busybox
COPY --from=0 /prometheus-status-pusher /usr/local/bin/
ENTRYPOINT [ "prometheus-status-pusher" ]
