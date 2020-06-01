#!/usr/bin/env bash

docker stop quiche
docker rm quiche
docker run \
--name quiche \
-p 127.0.0.1:30002:4433/udp \
-v $HOME/quic/www:/www \
-v $HOME/quic/certs:/certs \
-d \
quiche