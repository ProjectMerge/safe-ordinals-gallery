# Use the official Golang image as the base image
FROM golang:1.20.3 as builder

# Install required dependencies
RUN apt-get update && apt-get install -y \
     wget \
     git \
     gcc \
     unzip \
     build-essential \
     sqlite3 \
     libsqlite3-dev

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
RUN go mod tidy
RUN CGO_ENABLED=1 go build -o main .

#Use the official TensorFlow image as the base image
FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
     wget \
     curl \
     sqlite3 \
     libsqlite3-dev

# Debian based root certificates
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates

RUN update-ca-certificates

# Set the working directory
WORKDIR /app

RUN mkdir -p db

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main /app/main

# Set metadata
LABEL authors="M1chl"

# Run the application
CMD ["./main"]
