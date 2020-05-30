#!/usr/bin/env bash

QUICHE_CLI=/target/release/quiche-server
PORT=443

echo "Running QUIC server on 0.0.0.0:${PORT}"
${QUICHE_CLI} \
--listen 127.0.0.1:$PORT \
--cert /cert.crt \
--key /cert.key \
--root /www \