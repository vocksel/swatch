# syntax=docker/dockerfile:1

FROM rust:1.75.0 AS lune

ARG LUNE_VERSION

WORKDIR /app

RUN apt-get update && apt-get install -y curl unzip
RUN curl -LJO https://github.com/lune-org/lune/releases/download/v${LUNE_VERSION}/lune-${LUNE_VERSION}-linux-aarch64.zip
RUN unzip *.zip

FROM ubuntu:24.04 AS server

EXPOSE 8080
WORKDIR /app
COPY . .

# The server spawns processes for these commands
RUN apt-get update && apt-get install -y curl unzip

COPY --from=lune /app/lune /usr/local/bin

CMD ["lune", "run", "src/server.luau"]
