#!/usr/bin/env bash

docker rm quiche
docker run \
--name quiche \
-p 30000:443 \
-v $HOME/quic/www:/www \
quiche