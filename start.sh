#!/bin/bash
docker build --tag wasm-workshop --file setup.Dockerfile .
docker run --rm -it wasm-workshop