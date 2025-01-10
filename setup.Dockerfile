FROM rust:1.83-bookworm

RUN apt update && apt install -y curl pkg-config libssl-dev git

ENTRYPOINT ["/bin/bash"]
