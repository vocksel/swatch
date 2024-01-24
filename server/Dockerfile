# syntax=docker/dockerfile:1

FROM rust:1.75.0 AS build-lune

RUN apt-get update && apt-get install -y git gcc

# HACK: Need to install Lune from its main branch to bind servers to 0.0.0.0
RUN git clone https://github.com/lune-org/lune
RUN cargo build --release --manifest-path lune/Cargo.toml

FROM ubuntu:24.04 AS server

EXPOSE 8080
ARG LUNE_VERSION
VOLUME [ "/app/server" ]
WORKDIR /app

# Run as a non-privileged user
RUN adduser -ms /bin/bash -u 1001 appuser
USER appuser

# Copy source files into application directory
COPY --chown=appuser:appuser . /app

# The server spawns processes for these commands
RUN apt-get update && apt-get install -y curl unzip

COPY .env /app/.env
COPY --from=build-lune ./lune/target/release/lune /app/lune

CMD [ "./lune", "run", "server/server.luau" ]

# RUN curl -LJO https://github.com/lune-org/lune/releases/download/v${LUNE_VERSION}/lune-${LUNE_VERSION}-linux-aarch64.zip
# RUN unzip *.zip

# CMD [ "./lune", "server.luau" ]
