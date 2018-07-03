FROM golang:1.10
ENV IPATH=github.com/itskoko/prometheus-status-pusher
RUN go get -u github.com/golang/dep/cmd/dep
WORKDIR $GOPATH/src/$IPATH

ADD Gopkg.* ./
RUN dep ensure --vendor-only

ADD . .
RUN go test ./... && CGO_ENABLED=0 go install ./...

FROM busybox
COPY --from=0 /go/bin/* /usr/local/bin/
ENTRYPOINT [ "prometheus-status-pusher" ]
