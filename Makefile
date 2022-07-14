# small hack so we make sure we always have a GOPATH set
export GOPATH:=$(shell go env GOPATH)
export GO111MODULE:=on

# use gsed if available, sed otherwise
SED ?= $(shell which gsed || which sed)

all: ci

setup:
	@echo "~~~ go version"
	@go version
	@echo "~~~ install deps"
	@./hack/setup

lint:
	@echo "~~~ go lint"
	@GOGC=20 golangci-lint run --deadline=5m ./...

ci: build lint

# Build prometheus-statuspage-pusher binary
build:
	@echo "~~~ build api"
	@go build -o bin/prometheus-statuspage-pusher github.com/totvslabs/prometheus-statuspage-pusher

# gofmt and goimports all go files
fmt:
	find . -name '*.go' -not -wholename './vendor/*' | while read -r file; do gofmt -w -s "$$file"; goimports -w "$$file"; done
.PHONY: fmt
