#!/usr/bin/env bash

QLOG_DIR=$1
PORT=$2

docker stop proxygen
docker rm proxygen
docker run \
--name proxygen \
-p 127.0.0.1:$PORT:4433/udp \
-v $HOME/quic/www:/www \
-v $HOME/quic/certs:/certs \
-v $QLOG_DIR:/qlog \
-d \
proxygen
