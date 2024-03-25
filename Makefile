PROTOC_GEN_GO := $(GOPATH)/bin/protoc-gen-go

all:
	make install-deps
	make generate

install-deps:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

generate:
	protoc -I proto proto/sso/*.proto --go_out=./gen/go/ --go_opt=paths=source_relative --go-grpc_out=./gen/go/ --go-grpc_opt=paths=source_relative

clean:
	rm -f ./gen/go/*.go
