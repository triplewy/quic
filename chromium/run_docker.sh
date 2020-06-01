#!/usr/bin/env bash

docker stop chromium
docker rm chromium
docker run \
--name chromium \
-p 127.0.0.1:4433:4433/udp \
-v $HOME/quic/www:/www \
-v $HOME/quic/certs:/certs \
-d \
chromium
docker logs -f chromium