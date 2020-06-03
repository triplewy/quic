#!/usr/bin/env bash

QLOG_DIR=$1
PORT=$2

docker stop chromium
docker rm chromium
docker run \
--name chromium \
-p 127.0.0.1:$PORT:4433/udp \
-v $HOME/quic/www:/www/www.example.org \
-v $HOME/quic/certs:/certs \
-d \
chromium