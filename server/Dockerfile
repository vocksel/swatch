# syntax=docker/dockerfile:1

FROM rust:1.75.0 AS build-lune

RUN apt-get update && apt-get install -y git gcc

# HACK: Need to install Lune from its main branch to bind servers to 0.0.0.0
RUN git clone https://github.com/lune-org/lune
RUN cargo build --release --manifest-path lune/Cargo.toml

FROM ubuntu:24.04 AS server

EXPOSE 8080
WORKDIR /app
COPY . .

# The server spawns processes for these commands
RUN apt-get update && apt-get install -y curl unzip

COPY --from=build-lune ./lune/target/release/lune /usr/local/bin

CMD ["lune", "run", "src/server.luau"]
