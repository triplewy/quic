#!/usr/bin/env bash

export QLOGDIR="/qlog"
mkdir -p $QLOGDIR

QUICHE_CLI=/quiche-server
ROOT_DIR=/www
CERTS_DIR=/certs
PORT=4433

echo "Running QUIC server on 0.0.0.0:${PORT}"
${QUICHE_CLI} \
--listen 0.0.0.0:$PORT \
--cert $CERTS_DIR/leaf_cert.pem \
--key $CERTS_DIR/leaf_cert.key \
--root $ROOT_DIR \
--name 127.0.0.1 \
