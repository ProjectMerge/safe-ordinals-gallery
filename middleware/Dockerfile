# Use the official Golang image as the base image
FROM golang:1.20.3 as builder

# Install required dependencies
RUN apt-get update && apt-get install -y \
     wget \
     git \
     gcc \
    unzip \
     build-essential

# Install protobuf compiler and gRPC plugins
RUN apt-get install -y protobuf-compiler
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN mv /go/bin/protoc-gen-go* /usr/local/bin/

# Create a working directory for your Go project
WORKDIR /app

# Copy the Go project files into the container
COPY . .

# Create the required directories
RUN mkdir -p grpcModels

# Compile the .proto files
RUN cd ./proto && \
    protoc --go_out=../grpcModels --go_opt=paths=source_relative --go-grpc_out=../grpcModels --go-grpc_opt=paths=source_relative *.proto

# Build the Go project
RUN go mod tidy && \
    go build -o main .

#Use the official TensorFlow image as the base image
FROM debian:stable-slim

# Debian based root certificates
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates

RUN update-ca-certificates

COPY --from=builder /app/main .

LABEL authors="M1chl"

CMD ["./main"]