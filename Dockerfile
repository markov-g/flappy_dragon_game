FROM rust:1.55 as cargo-build

WORKDIR /usr/src/app
COPY ./src src
# COPY ./resources resources
COPY Cargo.lock .
COPY Cargo.toml .
RUN mkdir .cargo
RUN cargo vendor > .cargo/config
RUN cargo build --release
RUN cargo install --path . --verbose

FROM ubuntu:20.04
COPY --from=cargo-build /usr/local/cargo/bin/hello_bterm /bin
COPY --from=cargo-build /usr/src/app/ /src
COPY --from=cargo-build /usr/local/cargo/ /usr/local/cargo
# ARG DEBIAN_FRONTEND=noninteractive
# ENV TZ=Europe/Moscow
# Run apt-get update && apt-get install -y \
#     build-essential \
#     curl
# RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
# RUN apt-get update && apt-get install -y rustc git
# RUN cd /src && cargo build --release: