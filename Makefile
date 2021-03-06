GO_BUILD_ENV := CGO_ENABLED=0 GOOS=linux GOARCH=amd64
BUILD_DIR=$(shell pwd)/.build
CMD=$(BUILD_DIR)/mydiff

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: test
test: db_up
	go test -count=1 -v -mod=vendor ./go/...

.PHONY: coverage
coverage: db_up
	go test -count=1 -v -mod=vendor ./go/... -coverprofile .coverage
	go tool cover -html .coverage

.PHONY: build
build: clean
	mkdir -p $(BUILD_DIR)
	$(GO_BUILD_ENV) go build -v -o $(CMD) ./go/cmd

.PHONY: db_down
db_down:
	docker-compose down --volumes

.PHONY: db_up
db_up:
	docker-compose up -d --build

.PHONY: demo
demo: build db_up
	ruby ruby/demo.rb

