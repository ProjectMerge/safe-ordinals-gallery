#!/bin/zsh
protoc --dart_out=grpc:lib/generated -Iproto ./proto/phone.proto