#!/usr/bin/env bash

docker stop proxygen
docker rm proxygen
docker run \
--name proxygen \
-p 30000:443/udp \
-v $HOME/quic/www:/www \
-d \
proxygen