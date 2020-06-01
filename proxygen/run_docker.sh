#!/usr/bin/env bash

docker stop proxygen
docker rm proxygen
docker run \
--name proxygen \
-p 127.0.0.1:30001:4433/udp \
-v $HOME/quic/www:/www \
-v $HOME/quic/certs:/certs \
-d \
proxygen
