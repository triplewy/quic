#!/usr/bin/env bash

docker stop proxygen
docker rm proxygen
docker build . -t proxygen
docker run \
--name proxygen \
--port 443:443 \
-v $HOME/quic/www:/www \
proxygen