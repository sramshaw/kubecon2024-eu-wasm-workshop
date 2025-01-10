#!/bin/bash
docker build --tag wasm-workshop --file setup.Dockerfile .
docker run  --mount type=bind,src=/home/papa/_git2/wasix-rust-examples/wasix-grpc,dst=/root/wasix-grpc --rm -it wasm-workshop
