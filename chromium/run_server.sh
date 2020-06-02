#!/usr/bin/env bash

DRAFT=27
QUIC_CLI=/quic_server
ROOT_DIR=/www
CERTS_DIR=/certs
PORT=4433

echo "Running QUIC server on 0.0.0.0:${PORT}"
${QUIC_CLI} \
--port=$PORT \
--quic_response_cache_dir=$ROOT_DIR \
--certificate_file=$CERTS_DIR/leaf_cert.pem \
--key_file=$CERTS_DIR/leaf_cert.pkcs8 \
--v=1