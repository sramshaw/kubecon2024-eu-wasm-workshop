FROM rust:1.83-bullseye

RUN apt update && apt install -y curl pkg-config libssl-dev git

ENTRYPOINT ["/bin/bash"]
