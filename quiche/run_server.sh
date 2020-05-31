#!/usr/bin/env bash

export QLOGDIR="$HOME/qlog"
QUICHE_CLI=$HOME/quiche/tools/apps/target/release/quiche-server
PORT=4433

echo "Running QUIC server on 0.0.0.0:${PORT}"
${QUICHE_CLI} \
--listen 127.0.0.1:$PORT \
--cert $HOME/quic/chrome/out/leaf_cert.pem \
--key $HOME/quic/chrome/out/leaf_cert.key \
--root $HOME/quic/www/ \
--name 127.0.0.1 \
