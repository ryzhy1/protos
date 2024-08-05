# Установка зависимостей для генерации кода
PROTOC_GEN_GO := $(shell go env GOPATH)/bin/protoc-gen-go
PROTOC_GEN_GO_GRPC := $(shell go env GOPATH)/bin/protoc-gen-go-grpc
PROTOC_GEN_GRPC_GATEWAY := $(shell go env GOPATH)/bin/protoc-gen-grpc-gateway

all: install-deps generate

install-deps:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway

# Клонирование googleapis для импорта необходимых proto файлов
vendor-proto:
	@if [ ! -d vendor.protogen/google ]; then \
		git clone https://github.com/googleapis/googleapis vendor.protogen/googleapis && \
		mkdir -p vendor.protogen/google/ && \
		mv vendor.protogen/googleapis/google/api vendor.protogen/google && \
		rm -rf vendor.protogen/googleapis; \
	fi

# Генерация go кода из proto файлов
generate: vendor-proto
	protoc -I proto -I vendor.protogen proto/sso/*.proto --go_out=./gen/go/ \
	--go_opt=paths=source_relative \
	--go-grpc_out=./gen/go/ \
	--go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=./gen/go/ --grpc-gateway_opt=paths=source_relative

clean:
	rm -f ./gen/go/*.go
